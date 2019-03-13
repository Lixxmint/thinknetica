require_relative 'instance_counter'
require_relative 'validation'
require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  attr_reader :name, :stations

  validate :start, :type, Station
  validate :finish, :type, Station

  def initialize(name, start, finish)
    @name = name
    @stations = [start, finish]
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def del_station(station)
    @stations.delete(station) if @stations.first != station && @stations.last != station
  end

  # Для удаление пустых элементов.
  def route
    @stations.compact
  end
end
