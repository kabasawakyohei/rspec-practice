# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

# devDB初期化コマンド
docker-compose run web rails db:migrate:reset RAILS_ENV=test

# rspec実行コマンド
docker-compose run web bundle exec rspec spec/models/<filename>
