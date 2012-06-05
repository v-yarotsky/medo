begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  # Don't care
end
require 'aruba/cucumber'
require 'fileutils'

# Adds GLI's bin dir to our path
ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
GLI_LIB_PATH = File.expand_path(File.join(File.dirname(__FILE__),'..','..','lib'))

GLI_GEMSET = 'gli-testing'
TMP_PATH = 'tmp/aruba'

Before do
  # Not sure how else to get this dynamically
  @dirs = [TMP_PATH]
  @aruba_timeout_seconds = 5
  @original_path = ENV['PATH'].split(File::PATH_SEPARATOR)
  @original_home = ENV['HOME']
  new_home = "/tmp/fakehome"
  FileUtils.rm_rf new_home
  FileUtils.mkdir new_home
  ENV['HOME'] = new_home
end

After do |scenario|
  ENV['RUBYLIB'] = ''
  todo_app_dir = File.join(TMP_PATH,'todo')
  if File.exists? todo_app_dir
    FileUtils.rm_rf(todo_app_dir)
  end
  ENV['PATH'] = @original_path.join(File::PATH_SEPARATOR)
  ENV['HOME'] = @original_home
end

def add_to_path(dir)
  ENV['PATH'] = "#{dir}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
end

def add_to_lib_path(path)
  ENV["RUBYLIB"] = (String(ENV["RUBYLIB"]).split(File::PATH_SEPARATOR) + [path]).join(File::PATH_SEPARATOR)
end

def remove_from_lib_path(path)
  ENV["RUBYLIB"] = (String(ENV["RUBYLIB"]).split(File::PATH_SEPARATOR) - [path]).join(File::PATH_SEPARATOR)
end
