require 'rake/testtask'
require './lib/selfie/version'

Rake::TestTask.new do |t|
	t.libs << "lib/selfie.rb"
	t.test_files = FileList['test/*_test.rb']
	t.verbose = true
end

task :default => :test