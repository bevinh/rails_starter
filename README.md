# Description

This is a template with some basic things that I find I configure in a lot of Rails apps.

This uses:

- Postgres
- esbuild
- Bootstrap
- S3
- Rspec
- FactoryBot
- Faker
- Rubocop
- Simplecov

To run the template, you can either simply run:  
`ruby install.rb`

or you can create and go into a sites directory and run the installer directly:  
`rails new myApp --database=postgresql -j esbuild --css bootstrap -m ../template.rb`

I will be adding additional options in the future for colors, other libraries such as devise, noticed, and mailer configuration and potentailly more detailed templates.

## S3

I have included a .env file and Dotenv to configure s3. Use your own credentials to make the s3 storage work.

## User and Role Model

I have added a User Model with has_secure_password implementation. Users have two configurable roles.

The seeds file contains the current information as to the username and password in the default implementation.
