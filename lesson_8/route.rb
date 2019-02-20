require_relative 'instance_counter'
require_relative 'validation'
require_relative 'validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :name, :stations

  def initialize(name, start, finish)
    @name = name
    @stations = [start, finish]
    register_instance
  end

  def add_station(station)
    raise ArgumentError, "Станция #{station.name} уже есть маршруте" if @stations.include?(station)

    @stations.insert(-2, station)
  end

  def del_station(station)
    raise ArgumentError, "Станции #{station.name} нет в маршруте" unless @stations.index(station)
    raise ArgumentError, 'Нельзя удалить начальную или конечную станции' if @stations.first != station || @stations.last != station

    @stations.delete(station)
  end

  # Для удаление пустых элементов.
  def route
    @stations.compact
  end

  protected

  def validate!
    raise ArgumentError, 'Параметром маршрута должна быть станция' if @stations.find { |s| s.class != Station }
    raise ArgumentError, 'Начальная и конечная станции должны быть разные' if @start == @finish
  end
end
