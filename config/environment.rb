ENV['SINATRA_ENV'] ||= "development" #sets the sinatra_env db to development

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", #chooses the sqlite3 as the adapter for a local host connection
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite" #< in case would be db/development.sqlite
)

require_all 'app'