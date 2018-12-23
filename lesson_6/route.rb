require_relative 'instance_counter'
class Route
  include InstanceCounter
  attr_accessor :station_list, :name

  def initialize(name, start_station, last_station)
    @station_list = [start_station, last_station]
    @name = name
    register_instance
  end

  def add_station(station)
    @station_list.insert(-2, station) unless @station_list.include? station
  end

  def delete_station(station)
    @station_list.delete(station) if @station_list.first != station && @station_list.last != station
  end

  def show_stations
    @station_list.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end
  end
end
