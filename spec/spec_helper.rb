require 'isolate/now'
require 'minitest/spec'
require 'minitest/autorun'

$: << File.expand_path('../lib', File.dirname(__FILE__))

Dir.glob('./**/*_spec.rb').each do |s|
  require s
end if $0 == __FILE__
