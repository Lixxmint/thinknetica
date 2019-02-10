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
    test_date
  end
  def start
    loop do
      show_menu
      case gets.chomp
        when '1' then create_station
        when '2' then manage_trains
        when '3' then manage_route
        when '4' then show_stations_with_train
        when '0' then break
        else
          return
        end
    end
  end

  def show_menu
    puts "============Программа по управлению поездами============"
    puts "\nВыберете действие:\n
    [1] Создавать станцию
    [2] Управление поездом
    [3] Управлять маршрутом
    [4] Посмотреть список станций и список поездов на станции
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
  def manage_trains
    puts "\nУправление поездами:\n
    [1] Создать поезд
    [2] Установить маршрут поезду
    [3] Прицепить вагон поезду
    [4] Отцепить вагон от поезда
    [5] Двигать поезд
    [6] Управление вагонами
    [0] Выход"
    puts "=========================================================="
    case gets.chomp
      when '1' then create_trains
      when '2' then set_route
      when '3' then add_wagon
      when '4' then del_wagon
      when '5' then move_train
      when '6' then manage_wagon
      else
        return
      end
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
      volume = ask('Введите объём для нового вагона(ххх.x)',true)
      train.attach_wagon(CargoWagon.new(volume))
      puts "Вагон добавлен"
      train.train_info
    elsif train.type == :passenger
      seats = ask('Введите кол-во мест в вагоне(xx)',true)
      train.attach_wagon(PassengerWagon.new(seats))
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
    station = @stations[station_index]
    puts "\nСписок поездов на станции #{station.name}:\n=========\n"
    station.each_train do |train|
      puts "\n #{train.train_info}"
      show_wagons(train)
    end
  end
  def show_wagons(train)
    raise ArgumentError, 'У поезда нет вагонов' if train.wagons.empty?

    i = 0
    train.each_wagon do |wag|
      i += 1
      puts "[#{i}]\n=========\n"
      puts "#{wag.wagon_info}"
    end

    rescue ArgumentError => e
      puts e.message
  end

  def manage_wagon
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    return if train == 'exit'
    show_wagons(train)
    wagon = train.wagons[ask('Выберете вагон для использования',true)-1]
    if wagon.type == :cargo
      volume = ask('Сколько заполнять?',true)
      wagon.fill(value)
    else
      seats = ask("Напишите 'Y'для занятие места")
      if seats == 'Y'
        wagon.take_seat
      else
        return
      end
    end
    wagon.wagon_info
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
      puts "[#{index}]"
      puts "#{train.train_info}"
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

  def test_date
    #Станции
    @stations << s1 = Station.new("Station1")
    @stations << s2 = Station.new("Station2")
    @stations << s3 = Station.new("Station3")
    @stations << s4 = Station.new("Station4")
    @stations << s5 = Station.new("Station5")
    @stations << s6 = Station.new("Station6")
    #Поезда
    @trains << train1 = PassengerTrain.new("num-01")
    @trains << train2 = PassengerTrain.new("num-02")
    @trains << train3 = PassengerTrain.new("num-03")
    @trains << train4 = CargoTrain.new("num-04")
    @trains << train5 = CargoTrain.new("num-05")
    @trains << train6 = CargoTrain.new("num-06")
    #Маршруты
    @routes << route1 = Route.new("route1",s1,s2)
    @routes << route2 = Route.new("route2",s1,s2)
    @routes << route3 = Route.new("route3",s1,s2)
    #Вагоны
    wagon1 = CargoWagon.new(1200)
    wagon2 = CargoWagon.new(5600)
    wagon3 = CargoWagon.new(3100)
    wagon4 = CargoWagon.new(4200)
    wagon5 = PassengerWagon.new(64)
    wagon6 = PassengerWagon.new(64)
    wagon7 = PassengerWagon.new(32)
    wagon8 = PassengerWagon.new(32)

    train1.set_route(route1)
    train1.attach_wagon(wagon5)
    train1.attach_wagon(wagon6)
    train1.attach_wagon(wagon7)
    train1.attach_wagon(wagon8)
  end
end

Main.new.start
