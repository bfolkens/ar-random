require 'active_support/core_ext/module/delegation'
require 'active_record/relation'

module ARRandom
  module ActiveRecord
    module Relation

      # Return a randomly selected item
      def random(key = primary_key)
        relation = clone

        min_rec = relation.order("#{key} asc").select(key).first
        max_rec = relation.order("#{key} desc").select(key).first
        return relation.order("#{key} asc").first unless min_rec and max_rec and min_rec != max_rec

        min_id, clazz = encode_randomizing_value(min_rec.attributes[key.to_s])
        max_id, clazz = encode_randomizing_value(max_rec.attributes[key.to_s])

        # Caveat: these must end up being rounded or we won't retrieve all records
        rand_key = (rand(max_id - min_id + 1) + min_id).round
        relation.where("#{key} >= ?", decode_randomizing_value(rand_key, clazz)).order("#{key} asc").first
      end

      private

      def encode_randomizing_value(value)
        if value.kind_of? Time
          [value.to_f, value.class]
        else
          [value, value.class]
        end
      end

      def decode_randomizing_value(value, clazz)
        if clazz.name == 'Time'
          Time.at(value)
        else
          value
        end
      end
      
    end

    # Class methods
    module Base

      def random(key = primary_key)
        relation.random(key)
      end

    end
  end
end
