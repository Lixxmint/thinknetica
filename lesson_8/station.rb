require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

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

  protected

  def validate!
    raise ArgumentError, 'Название станции не указано' if @name.nil?
    raise ArgumentError, 'Название станции не может быть пустым' if @name.empty?
    raise ArgumentError, 'Станция с таким названием уже существует' if self.class.find(@name)
  end
end
