require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'wagon_passenger'
require_relative 'wagon_cargo'
require_relative 'company_module'

class Main

  def initialize
    @routes = []
    @stations = []
    @trains = []
    #test_date
  end
  def start
    loop do
      show_menu
      case gets.chomp
        when '1' then create_station
        when '2' then create_trains
        when '3' then manage_route
        when '4' then set_route
        when '5' then add_wagon
        when '6' then del_wagon
        when '7' then move_train
        when '8' then show_stations_with_train
        when '0' then break
        else
          return
        end
    end
  end
=begin
  def test_date
    @stations << s1 = Station.new("Station1")
    @stations << s2 = Station.new("Station2")
    @stations << s3 = Station.new("Station3")
    @stations << s4 = Station.new("Station4")

    @trains << train1 = PassengerTrain.new("num-01")
    @trains << train2 = PassengerTrain.new("num-02")
    @trains << train3 = PassengerTrain.new("num-03")
    @trains << train4 = CargoTrain.new("num-04")

    @routes << route1 = Route.new("new_route",s1,s2)
  end
=end
  def show_menu
    puts "============Программа по управлению поездами============"
    puts "\nВыберете действие:\n
    [1] Создавать станцию
    [2] Создавать поезд
    [3] Создать маршрут и управлять станциями в нем
    [4] Назначить маршрут поезду
    [5] Добавить вагон к поезду
    [6] Отцепить вагоны от поезда
    [7] Переместить поезд по маршруту вперед и назад
    [8] Посмотреть список станций и список поездов на станции
    [0] Выход"
  end
  def create_station
    puts "======Создать станцию======"
    name = ask('Введите название станции')
    @stations << Station.new(name)
    puts "Станция #{name} создана"
    rescue ArgumentError => e
      puts e.message
      retry
  end

  def create_trains
    puts "\nВыберете тип поезда:\n
    [1] Пассажирский
    [2] Товарный
    [0] Выход"
    puts "=========================================================="

    case gets.chomp
      when '1' then type = :passenger
      when '2' then type = :cargo
      else
        return
    end
    number = ask('Введите номер поезда')
    train = type == :passenger ? PassengerTrain.new(number) : CargoTrain.new(number)
    @trains << train
    puts "Объект создан"
    train.train_info
    rescue ArgumentError => e
      puts e.message
      retry
  end

  def manage_route
    puts "======Управление маршрутами======"
    puts "\nВыберете действие:\n
    [1] Создать маршрут
    [2] Редактировать
    [0] Выход"
    puts "=========================================================="

    case gets.chomp
      when '1' then create_route
      when '2' then edit_route
      else
        return
    end
  end

  def create_route
    puts "======Создать маршрут======"
    if @stations.size >= 2
      show_stations
      first = @stations[ask('Выберете начальную станцию',true)]
      last = @stations[ask('Выберете конечную станцию',true)]
      name = ask('Выберете название маршрута')
      @routes << Route.new(name, first, last)
      puts "Маршрут #{name} создан"
    else
      puts "Должно быть больше 2-х станций для создания маршрута"
    end
  end

  def edit_route
    puts "======Редатирование маршрута======"
    show_route
    route_index = ask('Выберете маршрут', true)
    if  @routes[route_index]
      route = @routes[route_index]
      puts "Маршрут => #{route_info(route)}"
      puts "\nВыберете действие:\n
      [1] Добавить станцию
      [2] Удалить станцию
      [0] Выход"
      puts "=========================================================="
      case gets.chomp
        when '1' then add_station_route(route)
        when '2' then del_station_route(route)
        else
          return
      end
    else
      puts "Маршрут не найден"
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
      puts "Нет такой станции"
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
      puts "Нет такой станции в маршруте"
    end
    rescue ArgumentError => e
      puts e.message
      retry
  end

  def set_route
    puts "============Назначить маршрут поезду============"
    show_route
    route_index = ask('Выберете маршрут', true)
    if @routes[route_index]
      route = @routes[route_index]
      show_train
      train_index = ask('Выберете поезд, которому назначить маршрут', true)
      if @trains[train_index]
        train = @trains[train_index]
        train.set_route(route)
        puts "Маршрут назначен"
        train.train_info
      else
        puts "Нет такого поезда"
      end
    else
      puts "Нет такого маршрута"
    end
  end

  def add_wagon
    puts "======Добавить вагон к поезду======"
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    if train == 'exit'
      return
    elsif train.type == :cargo
      train.attach_wagon(CargoWagon.new)
      puts "Вагон добавлен"
      train.train_info
    elsif train.type == :passenger
      train.attach_wagon(PassengerWagon.new)
      puts "Вагон добавлен"
      train.train_info
    else
      puts "Неверный тип поезда"
    end
    rescue ArgumentError => e
      puts e.message
      retry
  end

  def del_wagon
    puts "======Отцепить вагон от поезда======"
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    return if train == 'exit'
    train.detach_wagon
    puts "Вагон отцеплен"
    train.train_info
  end

  def move_train
    puts "======Переместить поезд======"
    show_train
    train = @trains[ask('Выберете поезд', true)]
    if train.route == nil
      puts "У поезда нет маршрута"
      return
    else
      train.train_info
      puts "\nВыберете действие:\n
      [1] Переместить вперед
      [2] Переместить назад
      [0] Выход"
      puts "============================="

      case gets.chomp
        when '1' then move_forward(train)
        when '2' then move_backward(train)
        else
          return
      end
    end
  end

  def move_forward(train)
    train.move_forward
    puts "Поезд перемещён вперёд"
  end

  def move_backward(train)
    train.move_backward
    puts "Поезд перемещён назад"
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] Станция #{station.name}"
    end
  end

  def show_stations_with_train
    puts "Список станций и поездов на станции"
    show_stations
    station_index = ask("Выберете станцию",true)
    return unless station_index
    station = @stations[station_index]
    if station
      puts "Список поездов на станции #{station.name}:"
      station.trains.each { |train| puts "#{train.train_info}"}
    else
      puts 'Неправильно указан индекс станции'
    end
  end

  protected

  def ask(que, int = false)
    puts que + ' '
    input = gets.chomp
    return nil if input == nil
    int ? input.to_i : input
  end

  def show_train
    @trains.each_with_index do |train, index|
      #индекс почему-то снизу отображается
      puts "[#{index}] #{train.train_info}"
    end
  end

  def show_route
    @routes.each_with_index do |route, index|
      puts "[#{index}] Маршрут #{route.name}"
    end
  end

  def route_info(route)
    return 'не задан' unless route

    points = []
    route.route.each { |r| points.push(r.name) }
    points.join('-')
  end
end

Main.new.start
