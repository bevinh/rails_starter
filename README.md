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

- Postgres, MySQL or MongoDB
- esbuild
- Bootstrap or Tailwind
- S3
- Rspec
- FactoryBot
- Faker
- Rubocop
- Simplecov
- Noticed

To run the template, you can either simply run:  
`ruby install.rb`

It will ask you a number of questions based on gems and whether you'll be pushing it to Heroku or not.

I will be adding additional options in the future for colors, other libraries such as devise, and mailer configuration and more detailed templates.

# For Postgres & MySQL Installs ONLY

## S3

If you are using activestorage (included with the MySQL and Postgresql database options) I have included a .env file and Dotenv to configure s3. Use your own credentials to make the s3 storage function.

## User and Role Model

I have added a User Model with has_secure_password implementation. Users have two configurable roles.

The seeds file contains the current information as to the username and password in the default implementation.
