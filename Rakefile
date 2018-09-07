# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'solr_wrapper/rake_task' unless Rails.env.production?

desc 'Run CI'
task ci: ['js:test'] do
end

namespace :js do
  task :test do
    sh 'npm run test'
  end
end

namespace :index do
  desc 'Load sample RIALTO solr docs'
  task :seed do
    file = File.expand_path(File.join('spec', 'fixtures', 'sample_solr_documents.yml'), __dir__)
    puts "Looking for #{file}"
    conn = Blacklight.default_index.connection
    conn.add YAML.load_file(file)
    conn.commit
  end
end
