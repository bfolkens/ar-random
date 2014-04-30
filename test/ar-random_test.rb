$:.unshift '.'; require File.dirname(__FILE__) + '/test_helper'

class ARRandomTest < Test::Unit::TestCase

  should 'should return nil when table is empty' do
    assert_equal 0, Item.count
    assert_nil Item.random
  end

  context '1 record in the table' do
    setup do
      @bottle = FactoryGirl.create(:item, :name => 'Bottle')
    end

    should 'select only existing record' do
      assert_equal 1, Item.count
      assert_equal @bottle, Item.random
    end
  end

  context '2 records in table' do
    setup do
      @bottle = FactoryGirl.create(:item, :name => 'Bottle')
      @cat = FactoryGirl.create(:item, :name => 'Cat')
    end

    should 'respect scope' do
      assert_equal @bottle, Item.where(:name => 'Bottle').random
    end

    should 'not return a record that does not match scope' do
      assert_nil Item.where(:name => 'Bogus').random
    end

    should 'eventually retrieve all possible records' do
      assert_all_records_retrieved
    end
  end

  context '3 records in table' do
    setup do
      @bottle = FactoryGirl.create(:item, :name => 'Bottle')
      @cat = FactoryGirl.create(:item, :name => 'Cat')
      @bag = FactoryGirl.create(:item, :name => 'Bag')
    end

    should 'eventually retrieve all possible records' do
      assert_all_records_retrieved
    end
  end

  def assert_all_records_retrieved
    scope_size = Item.count
    ids_found = []

    100.times do
      item = Item.random
      ids_found << item.id unless ids_found.include?(item.id)
      break if ids_found.size == 3
    end

    assert_equal Item.pluck(:id).sort, ids_found.sort
  end
end
