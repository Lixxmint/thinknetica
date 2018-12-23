require_relative 'instance_counter'
class Station
  include InstanceCounter
  attr_reader :all_train, :name

  @@stations = []
  def self.all
    @@stations
  end
  def initialize(name)
    @name = name
    @all_train = []
    @@stations << self
    register_instance
  end
  def add_train(train)
    @all_train << train
  end
  def trains_by_type(type)
    @all_train.select { |train| train.type == type }
  end
  def move_train(train)
    @trains.delete train
  end
end
