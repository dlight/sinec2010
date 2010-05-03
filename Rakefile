require 'rubygems'
require 'sinatra'
require 'dm-core'

namespace :db do
  DB_URL = "sqlite3://#{Dir.pwd}/db/sqlite3.db"
  puts DB_URL
  require 'src/login'
  require 'src/db'

  desc "Migrate the database"
  task :migrate do
    DataMapper.auto_migrate!
  end
  
  desc "Add some test users"
  task :addme do
    us = User.new
    us.email = 'tolkiendili@gmail.com'
    us.password = '123'
    us.page = 'elias'
    us.admin = true
    us.save
  end    
end
