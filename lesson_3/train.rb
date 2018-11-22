class Station
  attr_reader: all_train

  def initialize(name_station)
    @name_station = name_station
    @all_train = []
  end
  def add_train(train)
    @all_train << train
  end
  def delete_train(train)
    @train = train
    @all_train.delete_at(train)
  end
  def trains_by_type(type)
    #@all_train.each { |train| train if train.type == type} надо разобрать
  end
  def move_train(train)
    @trains.delete train
  end
end

class Route
  attr_accessor: station_list
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
    @station_list.each_with_index do |station, index|
      puts "#{index + 1}: #{station}"
    end
  end
end

class Train
  attr_accessor: speed
  attr_accessor: count_wagons

  def initialize(nubmer_train, type_train, count_wagons)
    @nubmer_train = nubmer_train
    @type_train = type_train
    @count_wagons = count_wagons
  end
  def edit_speed
    loop do
      puts "Выберете пункт чтобы изменить скорость\n 1. Прибавить скорость на 1 пункт\n 2. Снизить скорость до 0\n 0. Выход\n"
      speed_edit = gets.chomp
      if speed_edit == "1"
        @speed + 1
      elsif speed_edit == "2" && @speed > 0
        @speed = 0
      elsif speed_edit == "0"
        break
      else
        puts "Данная операция невозможна, т.к. скорость равна нулю, либо введена неверная команда"
      end
    end
  end
  def edit_wagons
    if(@speed.zero?)
      loop do
        puts "Выберете пункт чтобы изменить кол-во вагонов\n 1. Добавить один вагон\n 2. Убрать один вагон\n 0. Выход\n"
        operation_wagons = gets.chomp
        if operation_wagons == "1" && @count_wagons > 0
          @count_wagons + 1
        elsif operation_wagons == "2"
          @count_wagons - 1
        elsif operation_wagons == "0"
          break
        end
      end
    else
      puts "Данная операция недоступна, пока поезд движется"
    end
  end
