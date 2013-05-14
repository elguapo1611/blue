namespace :blue do
  desc "Move a basic set of configs into place"
  task :setup do
    puts "Copying configs into place inside your application..."
    puts ""

    gem_path = Bundler.load.specs.detect{|s| s.name == 'blue' }.try(:full_gem_path)

    puts "cp config/blue.yml"
    FileUtils.cp gem_path + "/templates/blue.yml", "config/blue.yml"
    puts "cp Capfile"
    FileUtils.cp gem_path + "/templates/Capfile", "Capfile"
    puts "cp config/deploy.rb"
    FileUtils.cp gem_path + "/templates/deploy.rb", "config/deploy.rb"

    FileUtils.mkdir_p("config/blue/boxes/production")
    puts "cp config/blue/boxes/production/some_hostname_com.rb"
    FileUtils.cp gem_path + "/templates/box.rb", "config/blue/boxes/production/some_hostname_com.rb"

    puts ""
    puts "#####################################################################"
    puts "##  Great! All done adding some configs.                           ##"
    puts "##  Now go read config/blue/boxes/production/some_hostname_com.rb  ##"
    puts "#####################################################################"
    puts ""
  end
end

