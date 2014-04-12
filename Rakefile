require "bundler"
Bundler.setup

require 'rake/testtask'

desc 'Test the library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

gemspec = eval(File.read("newgem.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["newgem.gemspec"] do
  system "gem build newgem.gemspec"
  system "gem install newgem-#{NewGem::VERSION}.gem"
end
