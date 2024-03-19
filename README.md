```
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
```

# Description

This is a template with some basic things that I find I configure in a lot of Rails apps. Yes, I made it fancy...I was having a day.

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
- Noticed (based on flag)

To run the template, you can either simply run:  
`ruby install.rb`

or you can create and go into a sites directory and run the installer directly:  
`rails new myApp --database=postgresql -j esbuild --css bootstrap -m ../template.rb`

If you are using the direct installer, you can add the flag --add-noticed to add the noticed gem, otherwise the regular installer walks through all of that.

I will be adding additional options in the future for colors, other libraries such as devise, and mailer configuration and potentailly more detailed templates.

# For everything but the MONGOID installs

## S3

If you are using activestorage (included with the MySQL and Postgresql database options) I have included a .env file and Dotenv to configure s3. Use your own credentials to make the s3 storage work.

## User and Role Model

I have added a User Model with has_secure_password implementation. Users have two configurable roles.

The seeds file contains the current information as to the username and password in the default implementation.
