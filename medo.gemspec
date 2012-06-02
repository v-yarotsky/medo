# -*- encoding: utf-8 -*-

require 'date'

$:.unshift File.expand_path('../lib/', __FILE__)

Gem::Specification.new do |s|
  s.name = "medo"
  s.summary = "Simple CLI todo manager app"
  s.version = Medo::VERSION

  s.authors = ["Vladimir Yarotsky"]
  s.date = Date.today.to_s
  s.email = "vladimir.yarotksy@gmail.com"
  s.homepage = "http://github.com/v-yarotsky/medo"
  s.licenses = ["MIT"]

  s.rubygems_version = "1.8.21"
  s.required_rubygems_version = ">= 1.3.6"
  s.specification_version = 3

  s.executables = ["medo"]
  s.files = Dir.glob("{bin,lib,spec}/**/*") + %w[Gemfile Gemfile.lock Rakefile LICENSE.txt README VERSION]
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<gli>, [">= 2.0.0.rc3"])
  s.add_development_dependency(%q<minitest>, ["~> 3.0"])
  s.add_development_dependency(%q<rake>, ["~> 0.9"])
end

