$:.unshift File.expand_path('./lib', __FILE__)

require 'rake/testtask'

desc "Run tests"
task :test do
    require 'jekyll-remote-plantuml'
    $:.unshift './test'
    Dir.glob('test/test*.rb').each { |t| require File.basename(t) }
end

task :default => :test

