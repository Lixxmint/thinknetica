require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'wagon_passenger'
require_relative 'wagon_cargo'
require_relative 'company_module'

class MainCommand

  def initialize
    @routes = []
    @stations = []
    @trains = []
    test_date
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
        end
    end
  end

  def test_date
    @stations << s1 = Station.new("station1")
    @stations << s2 = Station.new("station2")
    @stations << s3 = Station.new("station3")
    @stations << s4 = Station.new("station4")
    @stations << s5 = Station.new("station5")
    @stations << s6 = Station.new("station6")

    @trains << train1 = PassengerTrain.new("number")
    @trains << train2 = PassengerTrain.new("number2")
    @trains << train3 = PassengerTrain.new("number3")
  end

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
  end

  def create_trains
    puts "\nВыберете тип поезда:\n
    [1] Пассажирский
    [2] Товарный
    [0] Выход"
    puts "=========================================================="

    case gets.chomp
      when '1' then create_passenger_train
      when '2' then create_cargo_train
      when nil then return
    end
  end

  def create_cargo_train
    number = ask('Введите номер поезда')
    @trains << TrainCargo.new(number)
    puts "Грузовой поезд #{number} создан"
  end

  def create_passenger_train
    number = ask('Введите номер поезда')
    @trains << PassengerTrain.new(number)
    puts "Пассажирский поезд #{number} создан"
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
      when nil
    end
  end

  def create_route
    puts "======Создать маршрут======"
    if @stations.size > 2
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
      #route_info(route)
      puts "\nВыберете действие:\n
      [1] Добавить станцию
      [2] Удалить станцию
      [0] Выход"
      puts "=========================================================="
      case gets.chomp
        when '1' then add_station_route(route)
        when '2' then del_station_route(route)
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
      #route.show_route
    else
      puts "Нет такой станции"
    end
  end

  def del_station_route(route)
    #route.show_route
    station_index = ask('Выберете станцию для удаления', true)
    if @stations[station_index]
      station = @stations[station_index]
      route.del_station(station)
      puts "Станция #{station.name} удалена из маршрута"
      #route.show_route
    else
      puts "Нет такой станции"
    end
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
        puts "Маршрут #{route.name} назначен поезду #{train.number}"
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
    train = @trains[ask('Выберете поезд', true)]
    if train.type == :cargo
      train.attach_wagon(WagonCargo.new)
      train.train_info
    elsif train.type == :passenger
      train.attach_wagon(WagonPassenger.new)
      train.train_info
    else
      puts "Неверный тип поезда"
    end
  end

  def del_wagon
    puts "======Отцепить вагон от поезда======"
    show_train
    train = @trains[ask('Выберете поезд', true)]
    train.detach_wagon
    puts "Вагон отцеплен"
    train.train_info
  end

  def move_train
    puts "======Переместить поезд======"
    show_train
    train = @trains[ask('Выберете поезд', true)]
    return if train.route == nil
    train.train_info
    puts "\nВыберете действие:\n
    [1] Переместить вперед
    [2] Переместить назад
    [0] Выход"
    puts "============================="

    case gets.chomp
      when '1' then move_forward(train)
      when '2' then move_backward(train)
    end
  end

  def move_forward(train)
    train.move_forward
  end

  def move_backward(train)
    train.move_backward
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] Станция #{station.name}"
    end
  end

  def show_stations_with_train
    puts "Список станций и поездов на станции"
    show_stations
    station_index = show_message("Выберете станцию",true)
    return unless station_index
    station = @stations[station_index]
    if station
      puts "Список поездов на станции #{station.name}:"
      station.all_train.each { |train| puts "#{train}"}
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
      puts "[#{index}] Поезд #{train.number} - количество вагон #{train.wagons.size}"
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

MainCommand.new.start
