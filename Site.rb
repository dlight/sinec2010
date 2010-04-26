#!/usr/bin/env ruby
require 'rubygems'
require 'fileutils'
require 'sinatra'

set :run, true

# Read working dir. {{{1
idx = ARGV.index('--')
DIR = File.expand_path(
    if idx.nil? or ARGV[idx+1].nil?
        Dir.pwd
    else
        ARGV[idx+1]
    end
)

unless File.directory?(DIR)
    puts "No such directory: #{DIR}"
    exit -1
end

Dir.chdir(DIR)

CONF_FILE = "#{DIR}/conf.yml"
DB_URL = ENV['DATABASE_URL'] || "sqlite3://#{DIR}/db/sqlite3.db"
STYLES_FILE = "#{DIR}/views/base.sass"

require 'src/db'
require 'src/markup'
require 'src/qwicky'
require 'src/routes'
