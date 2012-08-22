require 'bundler/setup'
require 'aruba/cucumber'
require 'fileutils'

ENV['PATH'] = "#{File.expand_path('../../../bin', __FILE__)}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
ENV['GLI_DEBUG'] = "true"
ENV['RUBYLIB'] = File.expand_path('../../../lib', __FILE__)
After do
  if defined? @tasks_file_path and File.exist?(@tasks_file_path)
    FileUtils.rm(@tasks_file_path)
  end
end

