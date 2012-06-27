When /^I see tasks stored in (.*?)$/ do |filename|
  puts File.readlines(filename)
end

