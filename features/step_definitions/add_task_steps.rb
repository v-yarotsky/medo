Given /^there's no file "(.*?)"$/ do |file|
  FileUtils.rm file if File.exist?(file)
end
