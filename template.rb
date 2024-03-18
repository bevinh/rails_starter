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
  insert_into_file "app/views/layouts/application.html.erb", "<div class='container-fluid'>\n", after: "<body>\n"
  insert_into_file "app/views/layouts/application.html.erb", "</div>", before: "</body>\n"
  copy_file "./files/layout/_navigation.html.erb", "app/views/layouts/_navigation.html.erb"
  insert_into_file 'app/views/layouts/application.html.erb', "<%= render partial: 'layouts/navigation' %>\n", before: "<div class='container-fluid'>\n" 
  create_file "lib/templates/erb/scaffold/edit.html.erb.tt" do
    '
    <nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><%%= link_to "<%= plural_table_name.capitalize %>", <%= index_helper %>_path %></li>
    <li class="breadcrumb-item"><%%= link_to @<%= singular_table_name %>.id, @<%= singular_table_name %> %></li>
    <li class="breadcrumb-item active" aria-current="page">Edit</li>
  </ol>
</nav>
<%%= render "form", <%= singular_table_name %>: @<%= singular_table_name %> %>'
  end
  remove_file "lib/templates/erb/scaffold/_form.html.erb"
  create_file "lib/templates/erb/scaffold/_form.html.erb.tt" do
   ' <%% if <%= singular_table_name %>.errors.any? %>
  <%% <%= singular_table_name %>.errors.full_messages.each do |message| %>
  <div class="alert alert-danger" role="alert">
    <%%= message %>
  </div>
  <%% end %>
<%% end %>
<%%= form_with(model: <%= model_resource_name %>, local: true) do |form| -%>
<div class="card">
  <h5 class="card-header"><%= singular_table_name.capitalize %></h5>
  <ul class="list-group list-group-flush">
<% attributes.reject{|a| a.name == "type" || a.name == "deleted_at" || a.name.end_with?("_count")}.each do |attribute| -%>
    <li class="list-group-item">
      <div class="form-group">
<% if attribute.password_digest? -%>
        <%%= form.label :password, class: "font-weight-bold" %>
        <%%= form.password_field :password, placeholder: "Enter password", class: "form-control" %>
        <%%= form.label :password_confirmation, class: "fw-bold" %>
        <%%= form.password_field :password_confirmation, placeholder: "Enter password confirmation", class: "form-control" %>
<% else -%>
        <%%= form.label :<%= attribute.column_name %>, class: "fw-bold" %>
        <%%= form.<%= attribute.field_type %> :<%= attribute.column_name %>, placeholder: "Enter <%= attribute.column_name %>", class: "form-control" %>
<% end -%>
      </div>
    </li>
<% end -%>
  </ul>
  <div class="card-footer">
    <%%= link_to "Cancel", <%= model_resource_name %>, class: "btn btn-outline-secondary float-start" if <%= singular_table_name %>.persisted? %>
    <%%= link_to "Cancel", <%= index_helper %>_path, class: "btn btn-outline-secondary float-start" if !<%= singular_table_name %>.persisted? %>
    <%%= form.submit "Save", class: "btn btn-primary float-end" if <%= singular_table_name %>.persisted? %>
    <%%= form.submit "Create", class: "btn btn-primary float-end" if !<%= singular_table_name %>.persisted? %>
  </div>
</div>
<%% end %>
'
  end
  create_file "lib/templates/erb/scaffold/new.html.erb.tt" do
    '<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item"><%%= link_to "<%= plural_table_name.capitalize %>", <%= index_helper %>_path %></li>
      <li class="breadcrumb-item active" aria-current="page">Add</li>
    </ol>
  </nav>
  <%%= render "form", <%= singular_table_name %>: @<%= singular_table_name %> %>
  '
  end
  create_file "lib/templates/erb/scaffold/show.html.erb.tt" do
    '
    <nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><%%= link_to "<%= plural_table_name.capitalize %>", <%= index_helper %>_path %></li>
    <li class="breadcrumb-item active mr-auto" aria-current="page"><%%= @<%= singular_table_name %>.id %></li> 
  </ol>
</nav>
<div class="card">
  <h5 class="card-header"><%= singular_table_name.capitalize %></h5>
  <ul class="list-group list-group-flush">
<% attributes.reject{|a| a.name == "type" || a.name == "deleted_at" || a.name == "password_digest"}.each do |attribute| -%>
    <li class="list-group-item">
      <p class="fw-bold"><%= attribute.human_name %></p>
      <p class="fw-normal"><%%= @<%= singular_table_name %>.<%= attribute.name %> %></p>
    </li>
<% end -%>
  </ul>
</div>
'
  end
  create_file "lib/templates/erb/scaffold/index.html.erb.tt" do
    '<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
      <li class="breadcrumb-item active" aria-current="page"><%= plural_table_name.capitalize %></li>
    </ol>
  </nav>
  <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
    <%% @<%= plural_table_name %>.each do |<%= singular_table_name %>| %>
      <div class="col">
        <div class="card h-100">
          <div class="card-body">
            <h5 class="card-title"><%%= link_to <%= singular_table_name %>.id, <%= model_resource_name %> %></h5>
            <p class="card-text"><%%= <%= singular_table_name %>.inspect %></p>
          </div>
          <div class="card-footer">
            <small class="text-muted"><%%= <%= singular_table_name %>.created_at %></small>
          </div>
        </div>
      </div>
    <%% end %>
  </div>
  '
  end
  puts 'Adding models'
  generate "scaffold", "role name:string"
  generate "scaffold", "User email:string password_digest:string first_name:string last_name:string role:references"
  generate "controller", "home index"
  puts "Generating basic controllers"
  generate "controller", "sessions new create destroy"
  remove_file "app/views/sessions/new.html.erb"
  create_file "app/views/sessions/_form.html.erb" do
    '<%= form_with(url: "/sessions/create") do |form| %>
      <div class="form-floating mb-3">
        <%= form.email_field :email, class: "form-control", placeholder: "email" %>
        <%= form.label :email, class: "form-label" %>
    </div>
    <div class="form-floating">
      <%= form.password_field :password, class: "form-control", placeholder: "password" %>
      <%= form.label :password, class: "form-label" %>
    </div>
    <div class="mt-5">
      <%= form.submit "Sign In", class: "btn btn-primary" %>
    </div>
    <% end %>'
  end
  create_file "app/views/sessions/new.html.erb" do
     "<%= render partial: 'sessions/form' %>"
  end
  generate "controller", "registrations new create"
  insert_into_file "app/controllers/registrations_controller.rb", "@user = User.new\n
  @user.role = Role.find_by_name('user')", after: "def new\n"
  remove_file "app/views/registrations/new.html.erb"
  create_file "app/views/registrations/new.html.erb" do
      '<div class="p-5">
    <h4>Register: </h4>
    <%= render partial: "users/form", locals: { user: @user } %>
  </div>
  '
  end
  remove_file "app/views/registrations/_form.html.erb"
  create_file "app/views/users/_form.html.erb" do
    '<%= form_with(model: user, local: true) do |form| %>
      <div class="form-floating mb-3">
        <%= form.email_field :email, class: "form-control", placeholder: "email" %>
        <%= form.label :email, class: "form-label" %>
    </div>
    <div class="form-floating mb-3">
      <%= form.password_field :password, class: "form-control", placeholder: "password" %>
      <%= form.label :password, class: "form-label" %>
    </div>
    <div class="mt-5">
      <%= form.submit "Save Changes", class: "btn btn-primary" %>
    </div>
    <% end %>'
    end
  generate "controller", "password_resets new create edit update"
  generate "controller", "admin dashboard"
  generate "controller", "dashboard index"
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
git :init
git add: ".", commit: %(-m 'Initial commit')
