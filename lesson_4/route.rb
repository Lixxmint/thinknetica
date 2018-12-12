class Route
  attr_accessor :station_list, :name

  def initialize(name, start_station, last_station)
    @station_list = [start_station, last_station]
    @name = name
  end

  def add_station(station)
    @station_list.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if @station_list.first != station && @station_list.last != station
  end

  def show_stations
    @station_list.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end
  end
end
