require 'rake/testtask'
require './lib/selfie/version'

Rake::TestTask.new do |t|
	t.libs << "lib/selfie.rb"
	t.test_files = FileList['test/*_test.rb']
	t.verbose = true
end

task :install => :uninstall  do
  `rm *.gem`
  `gem build selfie.gemspec`
  `gem install --local selfie-#{Selfie::VERSION}.gem`
  `rbenv rehash`
end

task :default => :test