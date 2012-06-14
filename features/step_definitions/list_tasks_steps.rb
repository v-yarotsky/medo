Given /^I have the following tasks in "(.*?)"$/ do |filename, tasks|
  @tasks_file_path = filename
  File.open(filename, "w") do |f|
    f.write(tasks)
  end
end
