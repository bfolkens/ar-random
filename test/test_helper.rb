$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'factory_girl'
require 'faker'
require 'active_record'
require 'active_support/dependencies'
require 'ar-random'

MODELS_PATH = File.join(File.dirname(__FILE__), 'models')

config = YAML::load(File.open(File.expand_path("../databases.yml", __FILE__)))
version = ActiveRecord::VERSION::STRING
driver = (ENV["DB"] or "sqlite3").downcase
in_memory = config[driver]["database"] == ":memory:"
    
# http://about.travis-ci.org/docs/user/database-setup/
commands = {
  "mysql"    => "mysql -e 'create database arrandom_test;'",
  "postgres" => "psql -c 'create database arrandom_test;' -U postgres"
}
%x{#{commands[driver] || true}}
    
# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection config[driver]
puts "Using #{RUBY_VERSION} AR #{version} with #{driver}"

ActiveRecord::Base.connection.create_table(:items, :force => true) do |t|
  t.string   "name"
  t.datetime "created_at"
  t.datetime "updated_at"
end
  
# setup models for lazy load
dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift MODELS_PATH

# load factories now
require 'test/models/factories'

# clear db for every test
class Test::Unit::TestCase

  def setup
    Item.delete_all
  end

end


# Silence deprications
ActiveSupport::Deprecation.silenced = true
