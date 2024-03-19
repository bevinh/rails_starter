puts "Enter the Name of the Application"
app_name = gets.chomp
app_name = app_name.downcase.gsub(/\s+/, "_")
puts "Do you want to add noticed? Enter y for yes, and n for no"
noticed = gets.chomp.downcase

flags = ""
if noticed == "y"
  flags += " --add-noticed"
end

puts "Running Installer, please be patient, this may take awhile..."
`mkdir sites`
Dir.chdir "sites"
# Must use this in order to install the proper version of node
IO.popen(". $NVM_DIR/nvm.sh && nvm install 21.7.1") do |io| 
`rails new "#{app_name}" --database=postgresql -j esbuild --css bootstrap -m ../template.rb #{flags}`
`cd "#{app_name}" &&
 bundle install &&`
 puts 'Installation Complete'
 puts "run `cd sites/#{app_name} && foreman start -f Procfile.dev -p 5000` to start your server"
end