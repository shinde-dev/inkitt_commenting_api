# README

## Dependencies
* Ruby version : 3.0.0
* Rails Version : 6.1.4.1
* Postgresql : 12.9

## Environment Configuration
* Rename .env.example to .env and add values according to your local machine. Current values are set according to docker images.

## Manually Testing APIs
* Import postman collection added at root directory with file name Inkitt_commenting_api.postman_collection.json.
* Change postman collection values, ids e.g. parameters as per your local DB values. As of now, the values and ids are added according to seeded data.

## Setup with Docker

### Prerequisites

* Docker
* Docker-Compose

## Setup and start the applicaton with docker(use sudo with every docker command if you face permission issues)

### Stop local postgres service to avoid default port conflicts
```
$ sudo service postgresql stop
```

### Build docker image
```
$ docker-compose build
```

### Setup database
```
$ docker-compose run web rails db:create db:migrate db:seed
```

### Run the server
```
$ docker-compose up
```

### Run the Test Suit
```
$ docker-compose run web rspec
```

### Run the rubocop
```
$ docker-compose run web rubocop
```

## Setup and start the applicaton without Docker

### Install Dependencies
```
$ gem install bundler && bundle install
```

### Setup database
```
$ rake db:create db:migrate && rake db:seed
```

### Run the server
```
$ rails s
```

### Run the Test Suit
```
$ rspec
```

### Run the rubocop
```
$ rubocop
```

## Future Enhancements
* Using internationalisation gem I18n for translating application to a single custom language.
* Apply cursor based pagination.
* There is a scope of adding comment module serverless with NOSQL database. 