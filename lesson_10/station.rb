require_relative 'instance_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :name, :trains

  attr_accessor_with_history :name, :trains
  validate :name, :presence

  @@stations = []
  def self.all
    @@stations
  end

  def self.find(name)
    @@stations.find { |x| return x if x.name == name }
  end

  def initialize(name)
    @name = name.to_s
    validate!
    @trains = []
    @@stations << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def del_train(train)
    @trains.delete(train)
  end

  def trains_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_train
    @trains.each { |t| yield(t) }
  end

end
