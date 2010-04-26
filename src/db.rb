require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'

require 'logger'

# Database stuff. {{{1
class Page
    include DataMapper::Resource

    property :id, Serial
    property :name, Text, :required => true
    property :content, Text, :required => true
end

DataMapper::Logger.new(STDOUT, :debug)

DataMapper::setup(:default, DB_URL)

DataMapper::auto_upgrade!

#rescue Sqlite3Error => e
    #if e.message =~ %r{unable to open database file}
    #    $stderr.puts "Unable to create/open `#{DB_URL}'"
    #    $stderr.puts "Please make database file readable and writable."
    #    exit -1
    #else
    #    raise
    #end
#end
