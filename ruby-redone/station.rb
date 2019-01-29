require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []
  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.to_s
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
end
