namespace :blue do
  desc "Move a basic set of configs into place"
  task :setup_app do
    puts "Copying configs into place inside your application"
    puts ""

    puts "cp config/blue.yml"
    FileUtils.cp Blue::Box.gem_path + "/templates/blue.yml", "config/blue.yml"
    puts "cp Capfile"
    FileUtils.cp Blue.gem_path + "/templates/Capfile", "Capfile"
    puts "cp config/deploy.rb"
    FileUtils.cp Blue::Box.gem_path + "/templates/deploy.rb", "config/deploy.rb"

    FileUtils.mkdir_p("config/blue/production")
    puts "cp config/blue/production/some_hostname_com.rb"
    FileUtils.cp Blue::Box.gem_path + "/templates/box.rb", "config/blue/production/some_hostname_com.rb"

    puts ""
    puts "###############################################################"
    puts "##  Great! All done adding some configs.                     ##"
    puts "##  Now go read config/blue/production/some_hostname_com.rb  ##"
    puts "###############################################################"
    puts ""
  end

  desc "Verify Blue config"
  task :verify_boxes => :environment do
    Blue::Config.verify!
  end

  desc "Creates super and application users, copies ssh and sudoers configs into place."
  task :setup_boxes do
    Blue::Initializer.run!
  end
end

