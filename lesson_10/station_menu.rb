module StationMenu
  private

  def create_station
    puts '======Создать станцию======'
    name = ask('Введите название станции')
    @stations << Station.new(name)
    puts "Станция #{name} создана"
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def show_stations_with_train
    puts 'Список станций и поездов на станции'
    show_stations
    station_index = ask('Выберете станцию', true)
    station = @stations[station_index]
    puts "\nСписок поездов на станции #{station.name}:\n=========\n"
    station.each_train do |train|
      puts "\n #{train.train_info}"
      show_wagons(train)
    end
  end

  def add_station_route(route)
    show_stations
    station_index = ask('Выберете станцию для добавления', true)
    station = @stations[station_index]
    if @stations[station_index]
      route.add_station(station)
      puts "Станция #{station.name} добавлена в маршрут"
      puts "Маршрут => #{route_info(route)}"
    else
      puts 'Маршрут не найден'
    end
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def del_station_route(route)
    puts "Маршрут => #{route_info(route)}"
    show_stations
    station_index = ask('Выберете станцию для удаления', true)
    if route.stations[station_index]
      station = route.stations[station_index]
      route.del_station(station)
      puts "Станция #{station.name} удалена из маршрута"
      puts "Маршрут => #{route_info(route)}"
    else
      puts 'Нет такой станции'
    end
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] Станция #{station.name}"
    end
  end
end
