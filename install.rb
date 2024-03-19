require "colorize"
puts <<-'EOF'
                   _________
                  /_|_____|_\ 
                  '. \   / .'
                    '.\ /.'
                      '.'
    /\              |_   _|         | |      | | |
   /  \   _ __  _ __  | |  _ __  ___| |_ __ _| | | ___ _ __
  / /\ \ | '_ \| '_ \ | | | '_ \/ __| __/ _` | | |/ _ \ '__|
 / ____ \| |_) | |_) || |_| | | \__ \ |_ (_| | | |  __/ |
/_/    \_\ .__/| .__/_____|_| |_|___/\__\__,_|_|_|\___|_|
         | |   | |
         |_|   |_|
   EOF
puts "WELCOME TO MY RAILS APP INSTALLER".colorize(:color => :light_blue, :mode => :bold)
puts "This installer will walk you through a number of configuration steps to make it quicker and easier to create Rails Applications.".colorize(:color => :light_blue, :mode => :bold)
puts "You must have Rails installed to use this installer, if you do not, please install it before continuing."
  puts "Do you have Rails installed? Enter y for yes or n for no".colorize(:green)
  rails_installed = gets.chomp.downcase
  if rails_installed == "n"
    puts "Please install Rails and try again".white.on_red.blink
    exit
  end
puts "Rails is installed, continuing with questions..."
puts "Checking Rails Version"
rails_version = `rails -v`
if rails_version < "7.0"
  puts "Please update Rails to version 7.0+ and try again".white.on_red.blink
  exit
else 
  puts "Rails is at version 7.0+".colorize(:green)
end
puts "This application installer also requires Node to be installed. Do you have Node installed? Enter y for yes or n for no".colorize(:green)
node_installed = gets.chomp.downcase
if node_installed == "n"
  puts "Please install Node and try again".white.on_red.blink
  exit  
end
puts "Node is installed, continuing with questions..."
puts "This application installer also requires Node to be at version 20+"
puts "checking node version"
node_version = `node -v`
if node_version < "v20"
  puts "Please update Node to version 20+ and try again".white.on_red.blink
  exit
else
  puts "Node is installed".colorize(:green)
end
puts "This application installer also requires Foreman to be installed. Do you have Foreman installed? Enter y for yes or n for no".colorize(:green)
foreman_installed = gets.chomp.downcase
if foreman_installed == "n"
  puts "Please install Foreman and try again".white.on_red.blink
  exit
end
puts "Foreman is installed, continuing with questions..."

puts "Enter the Name You wish your Application to Have:".colorize(:green)
app_name = gets.chomp
app_name = app_name.downcase.gsub(/\s+/, "_")
puts "Which database would you like to use? Enter 1 for Postgres, 2 for MySQL or 3 for MongoDB".colorize(:green)
database = gets.chomp.to_i
noticed = "n"
if database != 3
  puts "Do you want to add noticed gem for notifications? Enter y for yes or n for no".colorize(:green)
  noticed = gets.chomp.downcase
end
puts "Will you deploy your app on Heroku? Enter y for yes or n for no".colorize(:green)
heroku_deploy = gets.chomp.downcase
if heroku_deploy == "y"
  puts "Have you installed the Heroku CLI? Enter y for yes or n for no".colorize(:green)
  heroku_cli = gets.chomp.downcase

  if heroku_cli == "n"
    `brew tap heroku/brew && brew install heroku`
  end
  if database == 2
    puts "I'm sorry, but Heroku does not support MySQL. Please choose another database. Please choose 1 for Postgres or 2 for MongoDB".colorize(:green)
    database = gets.chomp.to_i
  end
  puts "Do you want to automatically setup heroku to push updates? Enter y for yes or n for no".colorize(:green)
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
# Create a directory to install the sites
`mkdir sites`
Dir.chdir "sites"
# Start Mongo Services if we are using that database type
  if database == 3 
  `osascript -e 'tell app "Terminal"
      do script "brew services start mongodb-community@7.0"
  end tell'`
end

# Install the app
`rails new "#{app_name}" --skip-test --skip-system-test #{database} -j esbuild --css bootstrap -m ../template.rb #{flags}`
`cd "#{app_name}" &&
 bundle install &&`
 if heroku == "y"
  `heroku apps:create`
 end
 puts 'Installation Complete - Go forth and code!'.colorize(:color => :light_blue, :mode => :bold)
 puts "run `cd sites/#{app_name} && foreman start -f Procfile.dev -p 5000` to start your server".colorize(:green)

