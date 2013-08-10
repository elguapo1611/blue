module Blue
  module Initializer
    extend self

    def run!
      Blue::Box.boxes.each do |box|
        cmd = "ssh -q -o 'BatchMode yes' -o 'ConnectTimeout 5' #{box.cap_user_ip} 'echo > /dev/null'"
        cmd += " && echo $?"
        result = `#{cmd}`.strip
        # next if result == "0"
        puts "Initializing #{box.name}"
        puts "You will be prompted for #{box.cap_user_ip}'s password twice."
        copy_ssh_config(box) &&
        setup_sudoers(box)
      end
    end

    def copy_ssh_config(box)
      puts "Setting ssh rsa key access for #{box.cap_user_ip}:"
      cmd = [
        "cd ~/.ssh/",
        "tar czf ~/ssh.tar.gz id_rsa.pub id_rsa && scp ~/ssh.tar.gz #{box.cap_user_ip}:~/",
        "ssh #{box.cap_user_ip} 'rm -rf ~/.ssh/ || true && mkdir ~/.ssh/ && cd ~/.ssh/ && tar xf ~/ssh.tar.gz && cp id_rsa.pub authorized_keys && chmod -Rf 700 ~/.ssh'",
        "ssh #{box.cap_user_ip} 'rm ssh.tar.gz'",
        "rm ~/ssh.tar.gz"
      ].join(' && ')
      system cmd
    end

    def setup_sudoers(box)
      cmd = [
        "scp #{File.join(Blue::Box.gem_path, 'templates', 'finalize_init.sh')} #{box.cap_user_ip}:~/"
      ].join(' && ')
      system cmd

      puts "##"
      puts "##"
      puts "##  Now, you need to log into the box to run one more command"
      puts "##  I can't do it for you  :/"
      puts "##"
      puts "##  * ssh #{box.cap_user_ip}"
      puts "##"
      puts "##  * sudo USER=#{Blue.config.user} ./finalize_init.sh"
      puts "##"
      puts "##"
    end
  end
end

