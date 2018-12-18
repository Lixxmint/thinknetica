class Train
  attr_reader :count_wagons, :speed, :type, :number

  def initialize(number, type, count_wagons)
    @number = number
    @type = type
    @count_wagons = []
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
  def add_wagon(wagon)
    @count_wagons << wagon if @speed.zero?
  end
  def del_wagon
    @count_wagons.delete(-1) if @speed.zero?
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

  protected

  #данный момент используется только в других методах, и не должен использоваться пользователем
  def get_station_by_index(index)
    return nil if index < 0
    @route.station_list[index]
  end
end
