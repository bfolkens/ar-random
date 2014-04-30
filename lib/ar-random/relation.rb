require 'active_support/core_ext/module/delegation'
require 'active_record/relation'

module ARRandom
  module ActiveRecord
    module Relation

      # Return a randomly selected item
      def random
        relation = clone

        min_rec = relation.select(primary_key).first
        max_rec = relation.order("#{primary_key} desc").select(primary_key).first
        return relation.first unless min_rec and max_rec and min_rec != max_rec

        min_id = min_rec.attributes[primary_key]
        max_id = max_rec.attributes[primary_key]

        # Caveat: these must end up being rounded or we won't retrieve all records
        rand_key = (rand(max_id - min_id + 1) + min_id).round
        relation.where("#{primary_key} >= ?", rand_key).first
      end
      
    end

    # Class methods
    module Base

      def random
        relation.random
      end

    end
  end
end
