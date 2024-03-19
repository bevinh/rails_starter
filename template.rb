gem 'bcrypt'
gem 'rspec-rails', group: [:development, :test]
gem 'factory_bot_rails', group: [:development, :test]
gem 'faker', group: [:development, :test]
gem 'shoulda-matchers', group: [:development, :test]
gem 'database_cleaner-active_record', group: [:development, :test]
gem 'launchy', group: [:development, :test]
gem 'webdrivers', group: [:development, :test]

def source_paths
  [__dir__]
end

after_bundle do
  rails_command "db:create"
  generate "rspec:install"

  # Templates
  insert_into_file "app/views/layouts/application.html.erb", "<div class='container-fluid'>\n", after: "<body>\n"
  insert_into_file "app/views/layouts/application.html.erb", "</div>", before: "</body>\n"
  copy_file "./files/layout/_navigation.html.erb", "app/views/layouts/_navigation.html.erb"
  insert_into_file 'app/views/layouts/application.html.erb', "<%= render partial: 'layouts/navigation' %>\n", before: "<div class='container-fluid'>\n" 
 
  remove_file "lib/templates/erb/scaffold/_form.html.erb"
  copy_file "./files/templates/_form.html.erb.tt", "lib/templates/erb/scaffold/_form.html.erb.tt"
  copy_file "./files/templates/new.html.erb.tt", "lib/templates/erb/scaffold/new.html.erb.tt"
  copy_file "./files/templates/edit.html.erb.tt", "lib/templates/erb/scaffold/edit.html.erb.tt"
  copy_file "./files/templates/show.html.erb.tt", "lib/templates/erb/scaffold/show.html.erb.tt"
  copy_file "./files/templates/index.html.erb.tt", "lib/templates/erb/scaffold/index.html.erb.tt"
  # Models
  generate "scaffold", "role name:string"
  generate "scaffold", "User email:string password_digest:string first_name:string last_name:string role:references"
  # Controllers
  generate "controller", "home index"
  generate "controller", "sessions new create destroy"
  remove_file "app/views/sessions/new.html.erb"
  copy_file "./files/views/sessions/_form.html.erb", "app/views/sessions/_form.html.erb"
  copy_file "./files/views/sessions/new.html.erb", "app/views/sessions/new.html.erb"
  generate "controller", "registrations new create"
  insert_into_file "app/controllers/registrations_controller.rb", "@user = User.new\n
  @user.role = Role.find_by_name('user')", after: "def new\n"
  remove_file "app/views/registrations/new.html.erb"
  copy_file "./files/views/registrations/new.html.erb", "app/views/registrations/new.html.erb"
  remove_file "app/views/registrations/_form.html.erb"
  remove_file "app/views/users/_form.html.erb"
  copy_file "./files/views/users/_form.html.erb", "app/views/users/_form.html.erb"
  generate "controller", "password_resets new create edit update"
  generate "controller", "admin dashboard"
  generate "controller", "dashboard index"
  # Routes
  route "root 'home#index'"
  route ('get "/sessions/new", to: "sessions#new"')
  route ('post "/sessions/create", to: "sessions#create"')
  route ('delete "/sessions/delete", to: "sessions#destroy"')
  route "root 'admin#dashboard'", namespace: "admin"

  rails_command "db:migrate"
  puts "Migration Complete, adding security"
  insert_into_file "app/models/user.rb", "has_secure_password :password, validations: true
    validates :email, presence: true, uniqueness: true\n", :after => "class User < ApplicationRecord\n"
  insert_into_file "app/models/role.rb", "has_many :users\n", :after => "class Role < ApplicationRecord\n"

  insert_into_file "db/seeds.rb", "Role.create(name: 'admin')\nRole.create(name: 'user')\n"
  insert_into_file "db/seeds.rb", "User.create(email: 'test@test.com', password: 'password', first_name: 'Test', last_name: 'User', role: Role.find_by(name: 'user'))\n", :after => "Role.create(name: 'user')\n"
  insert_into_file "db/seeds.rb", "User.create(email: 'admin@test.com', password: 'password', first_name: 'Test', last_name: 'Admin', role: Role.find_by(name: 'admin'))\n", :after => "Role.create(name: 'admin')\n"
  insert_into_file "app/controllers/application_controller.rb", "private\n

    def require_signin
      unless signed_in?
        session[:intended_url] = request.url
        redirect_to signin_url
      end
    end
      
      def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      end
      
      helper_method :current_user
      
      def signed_in?
        !current_user.nil?
      end
      
      helper_method :signed_in?
      
      def current_user?(user)
        current_user == user
      end
      
      helper_method :current_user?\n", after: "class ApplicationController < ActionController::Base\n"
      insert_into_file "app/controllers/sessions_controller.rb", "user = User.find_by(email: params[:email])\n
      
      if user && user.authenticate(params[:password]) 
        session[:user_id] = user.id
        cookies[:user_id] = user.id
        redirect_to root_path
      else
        flash.now[:alert] = 'Invalid email/password combination!'
        render :new, status: :unprocessable_entity
      end", after: "def create\n"
      puts 'Adding security'
      insert_into_file "app/controllers/sessions_controller.rb", "session[:user_id] = nil
      cookies[:user_id] = nil
      redirect_to root_url", after: "def destroy\n"
      puts 'Adding security'
      

      rails_command "db:seed"
      
end
# Do some gitting
git :init
git add: ".", commit: %(-m 'Initial commit')

