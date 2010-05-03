require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'

require 'logger'
require 'digest/sha1'
require 'date'

# Database stuff. {{{1
class Page
    include DataMapper::Resource

    property :id, Serial
    property :name, Text, :required => true
    property :content, Text, :required => true
    #property :created_at, DateTime,	:default => DateTime.now
end

class User
  include DataMapper::Resource
  
  property :id,			Serial
  property :admin, Boolean, :default  => false
  property :hashed_password, 	String
  property :email,		String,	:key => true, :required => true,	:format => :email_address
  property :page,		String
  property :salt,		String
  property :created_at,		DateTime,	:default => DateTime.now
  
  validates_present :page, :email

  def password=(pass)
    @password = pass
    self.salt = Helpers::random_string(10) unless self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
  
  def self.authenticate(login, pass)
    u = User.first(:email => login)
    print "Debug: #{u}"
    print "Debug2: #{login}, #{pass}"
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
    nil
  end
end

DataMapper::Logger.new(STDOUT, :debug)

DataMapper::setup(:default, DB_URL)

#DataMapper::auto_upgrade!

#rescue Sqlite3Error => e
    #if e.message =~ %r{unable to open database file}
    #    $stderr.puts "Unable to create/open `#{DB_URL}'"
    #    $stderr.puts "Please make database file readable and writable."
    #    exit -1
    #else
    #    raise
    #end
#end
