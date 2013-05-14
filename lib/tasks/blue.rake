namespace :blue do
  desc "Move a basic set of configs into place"
  task :setup do
    gem_path = Bundler.load.specs.detect{|s| s.name == 'blue' }.try(:full_gem_path)

    puts "cp config/blue.yml"
    FileUtils.cp gem_path + "/templates/blue.yml", "config/blue.yml"
    puts "cp Capfile"
    FileUtils.cp gem_path + "/templates/Capfile", "Capfile"
    puts "cp config/deploy.rb"
    FileUtils.cp gem_path + "/templates/deploy.rb", "config/deploy.rb"
  end
end

