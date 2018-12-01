class Station
  attr_reader :all_train, :name

  def initialize(name)
    @name = name
    @all_train = []
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

class Route
  attr_accessor :station_list

  def initialize(start_station, last_station)
    @station_list = [start_station, last_station]
  end
  def add_station(station)
    @station_list.insert(-2, station)
  end
  def delete_station(station)
    @stations.delete(station) if @station_list.first != station && @station_list.last != station
  end
  def show_stations
    @station_list.each_with_index do |station, index|  puts "#{index + 1}: #{station.name}"
  end
end

class Train
  attr_reader :count_wagons, :speed, :type

  def initialize(nubmer, type, count_wagons)
    @nubmer = nubmer
    @type = type
    @count_wagons = count_wagons
    @route = nil
    @speed = 0
  end
  def speed_up(speed)
    @speed +=speed if @speed < 150
  end
  def speed_down(speed)
    @speed -=speed if @speed > 0
  end
  def stop
    @speed = 0
  end
  def add_wagon
    @count_wagons +=1 if @speed.zero?
  end
  def del_wagon
    @count_wagons -=1 if @speed.zero? && @count_wagons > 0
  end
  def set_route(route)
    @route = route
    @station_index = 0
  end
  def move_forward
    @station_index += 1 if @route.stations.size - 1 > @station_index
  end
  def move_backward
    @station_index -= 1 unless @station_index.zero?
  end
  def previous_station
    get_station_by_index @station_index - 1
  end
  def current_station
    get_station_by_index @station_index
  end
  def next_station
    get_station_by_index @station_index + 1
  end
  def get_station_by_index(index)
    return nil if index < 0
    @route.station_list[index]
  end
end
