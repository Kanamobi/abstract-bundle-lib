source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in abstract_bundle.gemspec
gemspec

gem 'activesupport'
gem 'bcrypt'
gem 'active_model_serializers'
gem 'redis'

# rspec
%w(rspec rspec-core rspec-mocks rspec-support
   rspec-its rspec-expectations).each do |repo|
  gem repo, github: "rspec/#{repo}", branch: :master
end