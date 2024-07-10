# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* [Ruby version](./.ruby-version) - `ruby-3.3.1`

* System dependencies
    - PostgreSQL server and client
    - Redis installation
    - Rails `7.1.3.4`
    - Gems from [Gemfile](./Gemfile)

* Build locally
    ```bash
    bin/bundle install
    bin/bundle exec rake assets:precompile
    bin/bundle exec rake assets:clean
    ```

* Database creation
    - Requires PostgreSQL DB installed either locally or on docker
    - Requires postgresql client installed on system

* Database initialization
    - Provide DB connection details in [`database.yml`](./config/database.yml)
    - Run for the first time setup:
        ```bash
        bin/rake db:drop 
        bin/rake db:create
        bin/rake db:migrate
        bin/rake db:seed
        ``` 

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
    - `sideqik` gem used for job queues for payment (fake [Paygo service](./lib/paygo.rb))
    - Redis DB required to be installed locally or on docker
    - Provide redis connection details in [sidekiq.rb](./config/initializers/sidekiq.rb)

* Deployment instructions
    * For the local dev environment, run `bin/rails server`
    * For production mode deployment:
        ```bash
        bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
        ```

The app is currently hosted as [Reservation Masters in render](https://reservation-masters.onrender.com) without sidekiq (Can take upto 2 min to load)