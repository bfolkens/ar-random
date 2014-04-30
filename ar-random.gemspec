$:.push File.expand_path("../lib", __FILE__)
require "ar-random/version"

Gem::Specification.new do |s|
  s.name        = "ar-random"
  s.license     = 'MIT'
  s.version     = ARRandom::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bradford Folkens"]
  s.homepage    = "https://github.com/bfolkens/ar-random"
  s.summary     = "Retrieve random records from ActiveRecord efficiently"
  s.files       = Dir['lib/**/*.rb']
  s.test_files  = Dir['test/**/*.rb']

  s.add_dependency 'rake'

  ar_env = ENV['ACTIVE_RECORD_VERSION'] || '>= 3.0.0'
  ar_env = ">= 4.0.0" if ar_env == 'latest'
  s.add_dependency 'activesupport', ar_env
  s.add_dependency 'activerecord', ar_env

  # for gem dev
  db_env = ENV['DB'] || 'sqlite3'
  case db_env 
  when 'sqlite3'
    s.add_development_dependency 'sqlite3', '1.3.7' 
  when 'mysql'
    if ar_env =~ /^3\.0/
      s.add_development_dependency 'mysql2', '< 0.3'
    else  
      s.add_development_dependency 'mysql2', '~> 0.3.11'
    end
  when 'postgres'
    s.add_development_dependency 'pg'
  end

  s.add_development_dependency "shoulda"
  s.add_development_dependency "factory_girl", "~> 3.0"
  s.add_development_dependency "faker"
end
