module Blue
  module Initializer
    extend self

    def run!
      Blue::Box.boxes.each do |box|
        cmd = [Blue.config.user, Blue.config.sudoer].map do |user|
          "ssh -q -o 'BatchMode yes' -o 'ConnectTimeout 5' #{box.user_ip} 'echo > /dev/null'"
        end.join(' && ')
        cmd += " && echo $?"
        result = `#{cmd}`.strip
        next if result == "0"
        puts "Initializing #{box.name}"
        puts "You will be prompted for #{box.sudoer_ip}'s password twice."
        copy_ssh_config(box) &&
        setup_sudoers(box)
      end
    end

    def copy_ssh_config(box)
      puts "Setting ssh rsa key access for #{box.sudoer_ip}:"
      cmd = [
        "cd ~/.ssh/",
        "tar czf ~/ssh.tar.gz id_rsa.pub id_rsa && scp ~/ssh.tar.gz #{box.ip}:~/",
        "ssh #{box.ip} 'mkdir ~/.ssh/ && cd ~/.ssh/ && tar xf ~/ssh.tar.gz && cp id_rsa.pub authorized_keys && chmod -Rf 700 ~/.ssh'",
        "ssh #{box.ip} 'rm ssh.tar.gz'",
        "rm ~/ssh.tar.gz"
      ].join(' && ')
      system cmd
      true
    end

    def setup_sudoers(box)
      cmd = [
        "scp #{File.join(Blue.gem_path, 'templates', 'finalize_init.sh')} #{box.ip}:~/"
      ].join(' && ')
      system cmd

      puts "##"
      puts "##"
      puts "##  Now, you need to log into the box to run one more command"
      puts "##  I can't do it for you  :/"
      puts "##"
      puts "##  * ssh #{box.sudoer_ip}"
      puts "##"
      puts "##  * sudo USER=#{Blue.config.user} ./finalize_init.sh"
      puts "##"
      puts "##"

      true
    end
  end
end

