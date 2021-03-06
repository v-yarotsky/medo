# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../lib/', __FILE__)

require 'medo'
require 'date'

Gem::Specification.new do |s|
  s.name = "medo"
  s.summary = "Simple CLI todo manager app"
  s.description = <<-TXT
The 'medo' application allows you to keep track of your
tasks (basically a to-do app) through command line interface
  TXT

  s.version = Medo::VERSION.dup

  s.authors = ["Vladimir Yarotsky"]
  s.date = Date.today.to_s
  s.email = "vladimir.yarotksy@gmail.com"
  s.homepage = "http://github.com/v-yarotsky/medo"
  s.licenses = ["MIT"]

  s.rubygems_version = "1.8.21"
  s.required_rubygems_version = ">= 1.3.6"
  s.specification_version = 3

  s.executables = ["medo"]
  s.files = Dir.glob("{bin,lib,spec,features}/**/*") + %w[Gemfile Gemfile.lock Rakefile LICENSE.txt README.md VERSION]
  s.require_paths = ["lib"]

  s.add_runtime_dependency("gli", ">= 2.0.0.rc4")
  s.add_runtime_dependency("rainbow", "~> 1.1")
  s.add_runtime_dependency("json", "~> 1.7")
  s.add_development_dependency("rspec", "~> 2.11")
  s.add_development_dependency("rake",  "~> 0.9")
  s.add_development_dependency("aruba", "~> 0.4")
  s.add_development_dependency("simplecov", "~> 0.6")
end

