require 'spec/helper'

testcase_requires 'sequel', 'sequel/sqlite'

DB = Sequel('sqlite:/')

require 'ramaze/contrib/sequel/fill'

class Person < Sequel::Model(:person)
  set_schema do
    primary_key :id
    text :name
  end
end

Person.create_table!

class MainController < Ramaze::Controller
  def index
    'Hello, World!'
  end

  def insert
    person = Person.fill
    person.save
  end

  def show id
    Person[id.to_i].name
  end
end

describe 'Route' do
  before :all do
    ramaze
  end

  it 'should fill values from current request' do
    insert = get('/insert', 'name' => 'manveru')
    insert.status.should == 200
    person = get('/show/1')
    person.body.should == 'manveru'
  end
end
