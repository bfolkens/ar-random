require 'ar-random/version'
require 'ar-random/relation'

class ActiveRecord::Relation
  include ARRandom::ActiveRecord::Relation
end

class ActiveRecord::Base
  extend ARRandom::ActiveRecord::Base
end
