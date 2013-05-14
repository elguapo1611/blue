namespace :blue do
  desc "Move a basic set of configs into place"
  task :setup do
    puts "cp config/blue.yml"
    FileUtils.cp Bundler.load.specs.detect{|s| s.name == 'blue' }.try(:full_gem_path) + "/templates/blue.yml", "config/blue.yml"
  end
end

