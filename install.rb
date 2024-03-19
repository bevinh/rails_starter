puts "Enter the Name of the Application"
app_name = gets.chomp
app_name = app_name.downcase.gsub(/\s+/, "_")
puts "Which database would you like to use? Enter 1 for Postgres, 2 for MySQL or 3 for MongoDB"
database = gets.chomp.to_i
puts "Do you want to add noticed gem for notifications? Enter y for yes or n for no"
noticed = gets.chomp.downcase
puts "Will you deploy your app on Heroku? Enter y for yes or n for no"
heroku_deploy = gets.chomp.downcase
if heroku_deploy == "y"
  puts "Have you installed the Heroku CLI? Enter y for yes or n for no"
  heroku_cli = gets.chomp.downcase

  if heroku_cli == "n"
    `brew tap heroku/brew && brew install heroku`
  end
  puts "Do you want to automatically setup heroku to push updates? Enter y for yes or n for no"
    heroku = gets.chomp.downcase
end



flags = ""
if noticed == "y"
  flags += " --add-noticed"
end
if database == 1
  flags += " --database=postgresql"
elsif database == 2
  flags += " --database=mysql"
elsif database == 3
  flags += " --skip-active-record"
  flags += " --use-mongoid"
end



puts "Running Installer, please be patient, this may take awhile..."
`mkdir sites`
Dir.chdir "sites"
  if database == 3 
  `osascript -e 'tell app "Terminal"
      do script "echo hello"
  end tell'`
end
# Must use this in order to install the proper version of node
IO.popen(". $NVM_DIR/nvm.sh && nvm install 21.7.1 && nvm use 21.7.1") do |io| 
`rails new "#{app_name}" --skip-test --skip-system-test #{database} -j esbuild --css bootstrap -m ../template.rb #{flags}`
`cd "#{app_name}" &&
 bundle install &&`
 if heroku == "y"
  `heroku apps:create`
 end
 puts 'Installation Complete'
 puts "run `cd sites/#{app_name} && foreman start -f Procfile.dev -p 5000` to start your server"

end