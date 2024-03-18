puts "Enter the Name of the Application"
app_name = gets.chomp
app_name = app_name.downcase.gsub(/\s+/, "_")

puts "Running Installer, please be patient, this may take awhile..."
Dir.chdir "sites"
# Must use this in order to install the proper version of node
IO.popen(". $NVM_DIR/nvm.sh && nvm install 21.7.1") do |io| 
`rails new "#{app_name}" --database=postgresql -j esbuild --css bootstrap -m ../template.rb`
`cd "#{app_name}" &&
 bundle install &&`
 puts 'Installation Complete'
 puts "run `cd sites/#{app_name} && foreman start -f Procfile.dev -p 5000` to start your server"
end