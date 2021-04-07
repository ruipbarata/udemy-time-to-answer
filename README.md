# Time to Answer
This project follow the [Ruby on Rails 5.x - Do início ao fim!](https://www.udemy.com/share/101vRoAEATdlhbTXQD/)

#### Dependencies
- Ruby [2.4.5](https://www.ruby-lang.org/)
- Rails [5.2.1](https://rubyonrails.org/)

#### Recommendations
* [Ruby Version Manager (RVM)](https://rvm.io)
* [Node Version Manager (NVM)](https://github.com/nvm-sh/nvm)

##### 1. Create and setup the database

Run the following commands to create and setup the database.

```bash
rails db:create
rails db:migrate
```

##### 2. Populate database

Run the following command to create the default administrator.

```bash
rails dev:add_default_admin # Register the default administrator
```

You can populate the database with more data, with the following commands
```bash
rails dev:add_extras_admins # Register extra administrators
rails dev:add_default_user # Register a default user
rails dev:add_subjects # Register default subjects
rails dev:add_answers_and_questions # Register default questions and aswers 
```

Or, the following command to execute all the commands above
```bash
rails dev:setup
```

##### 3. Start the Rails server

You can start the rails server using the command given below.

```bash
rails s (default port number - 3000)
rails s -p <port number>
```

#### Try it:

```bash
curl localhost:3000
```

And now you can visit the site with the URL http://localhost:3000