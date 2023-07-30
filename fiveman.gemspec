$:.unshift File.expand_path("../lib", __FILE__)
require "fiveman/version"

Gem::Specification.new do |gem|
  gem.name     = "fiveman"
  gem.license  = "MIT"
  gem.version  = Fiveman::VERSION

  gem.author   = "David Dollar"
  gem.email    = "ddollar@gmail.com"
  gem.homepage = "https://github.com/ddollar/fiveman"
  gem.summary  = "Process manager for applications with multiple components"

  gem.description = gem.summary

  gem.executables = "fiveman"
  gem.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }
  gem.files << "man/fiveman.1"
end
