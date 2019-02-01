require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :name, :stations

  def initialize(name, start, finish)
    @name = name
    @stations = [start, finish]
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station) if @stations.first != station && @stations.last != station
  end

  def del_station(station)
    @stations.delete(station) if @stations.first != station && @stations.last != station
  end

#Для удаление пустых элементов.
  def route
    @stations.compact
  end
end
