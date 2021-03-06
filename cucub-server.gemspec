# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cucub-server"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fernando Alonso"]
  s.date = "2012-10-24"
  s.description = "longer description of your gem"
  s.email = "krakatoa1987@gmail.com"
  s.executables = ["cucub-server"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/cucub-server",
    "config/protocol.ini",
    "cucub-server.gemspec",
    "examples/boot.rb",
    "examples/reply_channel_test.rb",
    "lib/channel.rb",
    "lib/cucub-server.rb",
    "lib/dispatcher.rb",
    "lib/server.rb",
    "lib/server/cli.rb",
    "lib/server/configuration.rb",
    "lib/server/servolux.rb",
    "spec/configuration_spec.rb",
    "spec/spec_helper.rb",
    "test/helper.rb",
    "test/test_cucub-server.rb"
  ]
  s.homepage = "http://github.com/krakatoa/cucub-server"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "one-line summary of your gem"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<servolux>, [">= 0"])
      s.add_runtime_dependency(%q<ma-zmq>, [">= 0"])
      s.add_runtime_dependency(%q<cucub-protocol>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.2.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<servolux>, [">= 0"])
      s.add_dependency(%q<ma-zmq>, [">= 0"])
      s.add_dependency(%q<cucub-protocol>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.2.1"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<servolux>, [">= 0"])
    s.add_dependency(%q<ma-zmq>, [">= 0"])
    s.add_dependency(%q<cucub-protocol>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.2.1"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.4"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

