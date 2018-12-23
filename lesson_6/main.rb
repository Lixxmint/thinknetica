require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'company_module'


class Main

  def initialize
    @stations = []
    @trains = []
    @routes = []
    test_date
  end
  def test_date
    @stations << s1 = Station.new("station1")
    @stations << s2 = Station.new("station2")
    @stations << s3 = Station.new("station3")
    @stations << s4 = Station.new("station4")
    @stations << s5 = Station.new("station5")
    @stations << s6 = Station.new("station6")

    @trains << ct1 = CargoTrain.new("cargo_train1")
    @trains << ct2 = CargoTrain.new("cargo_train2")
    @trains << ct3 = CargoTrain.new("cargo_train3")
    @trains << pt1 = PassengerTrain.new("passenger_train1")
    @trains << pt2 = PassengerTrain.new("passenger_train2")
    @trains << pt3 = PassengerTrain.new("passenger_train3")

    @routes << route1 = Route.new("new_route","station1","station2")

    @trains[3].set_route(@routes[0])
  end
  def start
    loop do
      show_menu
      case gets.chomp
        when '1' then create_station
        when '2' then create_trains
        when '3' then manage_route
        when '4' then assign_route
        when '5' then attach_wagon_to_train
        when '6' then detach_wagon_of_train
        when '7' then move_train
        when '8' then show_stations_with_train
        when '0' then break
        end
    end
  end
#будет использовано только в другом методе, в одном классе.
private
  def create_station#Создавать станции
    puts "============Создание станции============"
    loop do
      station_name = show_message("Введите название станции или ENTER для завершения")
      break if station_name.empty?
      @stations << Station.new(station_name)
      puts "Станция #{station_name} успешно создана"
    end
  end
#Создавать поезда
  def create_trains
    loop do
      puts "============Создание поездов============"
      puts "Выберете тип поезда для создания:\n
      [1] Создавать пассажирский поезд
      [2] Создавать грузовой поезд
      [0] Назад
      "
      train_type = gets.chomp.to_i
      break if train_type.nil?
      train_name = show_message("Введите название поезда или ENTER для завершения")
      if train_type == 1
        train = PassengerTrain.new(train_name)
        puts "Пассажирский поезд c номером #{train.number} успешно создан"
        @trains << train
      elsif train_type == 2
        train = CargoTrain.new(train_name)
        puts "Товарный поезд c номером #{train.number} успешно создан"
        @trains << train
      elsif train_name.empty?
        return
      else
        puts "Ошибка ввода"
      end
    end
  end
#Добавлять вагоны к поезду
  def attach_wagon_to_train
    loop do
      show_train
      puts "Выберете поезд"
      train_index = show_message("Выберете поезд или ENTER для завершения", true)
      break if train_index.nil?
      train = @trains[train_index]
      if train.type == "cargo"
        wagon = CargoWagon.new
        train.add_wagon(wagon)
        puts "Вагон прицеплен к поезду #{train.number}"
      elsif train.type == "passenger"
        wagon = PassengerWagon.new
        train.add_wagon(wagon)
        puts "Вагон прицеплен к поезду #{train.number}"
      else
        puts "Неверный ввод"
      end
    end
  end
#Отцеплять вагоны от поезда
  def detach_wagon_of_train
    show_train
    train_index = show_message("Выберете поезд", true)
    train = @trains[train_index]
    if train
      train.del_wagon
      puts "От поезда #{train.number} отцеплён вагон"
    else
      puts "Данный поезд не найден"
    end
  end

  def show_train
    @trains.each_with_index do |train, index|
      puts "[#{index}] Поезд #{train.number} - количество вагон #{train.wagons.size}"
    end
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] Станция #{station.name}"
    end
  end

  def show_route
    @routes.each_with_index do |route, index|
      puts "[#{index}] Маршрут #{route.name}"
    end
  end
#Создавать маршруты и управлять станциями в нем (добавлять, удалять)
  def manage_route
    loop do
      puts "============Менеджер маршрутами============"
      puts "Выберете действие:\n
      [1] Создавать маршрут
      [2] Управление маршрутом
      [0] Назад
      "
      action_route = gets.chomp.to_i
      break if action_route.nil?
      if action_route == 1
        create_route
      elsif action_route == 2
        puts "============Управление маршрутами============"
        puts "Выберете маршрут:"
        show_route
        route = @routes[show_message("Выберете маршрут:", true)]
        puts "Выберете действие:\n
        [1] Добавить станцию
        [2] Удалить станцию
        [0] Назад
        "
        case gets.chomp
          when '1' then add_station_route(route)
          when '2' then del_station_in_route(route)
        end
      else
        puts "Команда не найдена!"
        return
      end
    end
  end
  #Метод для добавления станций в маршрут
  def add_station_route(route)
    show_stations
    station =  show_message("Выберете станцию для добавления", true)
    if @stations[station]
      route.add_station(@stations[station])
      puts "Станция успешно добавлена"
    else
      puts "Станция не найдена или уже добавлена"
      return
    end
  end
  #Метод для удаления станции из маршрута
  def del_station_in_route(route)
    puts "Список станций маршрута #{route.name}"
    route.show_stations
    station = show_message("Выберете станцию для удаления", true)
    return if station.nil?
    if route.delete_station(route.show_stations[station])
      puts "Станция успешно удалена!"
    else
      puts "Неверный индекс"
    end
  end
  #Метод для создания маршрута
  def create_route
    if @stations.size > 2
      puts "============Создание нового маршрута============"
      name = show_message("Введите имя маршрута")
      puts "Доступные станции для добавления:"
      show_stations
      first_station = @stations[show_message("Выберете начальную станцию", true)]
      last_station = @stations[show_message("Выберете конечную станцию", true)]
      @routes << route = Route.new(name, first_station, last_station)
      puts "Маршрут #{name} успешно создан"
    else
      puts "Необходимо больше 2-х станций для создание маршрута"
    end
  end
  #Метод для ввывода сообщения и возврата переменной, ввёдной пользователем
  def show_message(message, int = false)
    print "#{message}\n"
    input = gets.chomp
    return nil if input == nil
    int ? input.to_i : input
  end
#Назначать маршрут поезду
  def assign_route
    puts "============Назначение маршрута поезду============"
    show_train
    train = show_message("Выберете поезд",true)
    if @trains[train]
      puts "Список маршрутов:\n"
      show_route
      route = show_message("Выберете маршрут",true)
      if @routes[route]
        @trains[train].set_route(@routes[route])
        puts "Маршрут установлен!"
      else
        "Маршрут не найден"
      end
    else
      puts "Указанный поезд не найден!"
    end
  end
#Перемещать поезд по маршруту вперед и назад
  def move_train
    puts "============Перемещение поезда по маршруту============"
    show_train
    train = @trains[show_message("Выберете поезд для перемещения", true)]
    if train
      loop do
        puts "Поезд #{train.number} находится на станции #{train.current_station}"
        puts "[n] - для перемещения на следующую станцию"
        puts "[p] - для перемещения на предыдущую станцию"
        action = show_message("")
        break if action.empty?
        if action == "n"
          train.move_forward
        elsif action == "p"
          train.move_backward
        end
      end
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
end

Main.new.start
