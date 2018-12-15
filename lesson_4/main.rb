require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'cargo_wagon'


class Main

  def initialize
    @stations = []
    @trains = []
    @routes = []
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
      station_name = show_messange("Введите название станции или '0' для завершения")
      break if station_name == "0"
      station = Station.new(station_name)
      puts "Станция #{station.name} успешно создана"
      @stations << station
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
      break if train_type == 0
      train_name = show_messange("Введите название поезда или '0' для завершения", true)
      if train_type == 1
        train = PassengerTrain.new(train_name)
        puts "Пассажирский поезд c номером #{train.number} успешно создан"
        @trains << train
      elsif train_type == 2
        train = CargoTrain.new(train_name)
        puts "Товарный поезд c номером #{train.number} успешно создан"
        @trains << train
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
      train_index = show_messange("Выберете поезд или '0' для завершения", true)
      break if train_index == 0
      train = @trains[train_index]
      if train.type == "cargo"
        wagon = CargoWagon.new
        train.add_wagon(wagon)
        puts "Вагон прицеплен к поезду #{train}"
      elsif train.type == "passenger"
        wagon = PassengerWagon.new
        train.add_wagon(wagon)
        puts "Вагон прицеплен к поезду #{train.number}"
      else
        puts "Поезд с номером #{train.number} не существует!"
      end
    end
  end
#Отцеплять вагоны от поезда
  def detach_wagon_of_train
    show_train
    train_index = show_messange("Выберете поезд", true)
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
      puts "[#{index}] Поезд #{train.number} - количество вагон #{train.count_wagons.size}"
    end
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] Станция #{station.name}"
    end
  end

  def show_route
    puts "Список поездов:\n"
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
      break if action_route == "0"
      if action_route == 1
        create_route
      elsif action_route == 2
        puts "============Управление маршрутами============"
        puts "Выберете маршрут:"
        show_route
        route = @routes[show_messange("Выберете маршрут:", true)]
        puts "Выберете действие:\n
        [1] Добавить станцию
        [2] Удалить станцию
        [0] Назад
        "
        case gets.chomp
          when '1' then add_station_route
          when '2' then del_station_in_route
        end
      else
        puts "Команда не найдена!"
      end
    end
  end
  #Метод для добавления станций в маршрут
  def add_station_route
    show_stations
    station =  @stations[show_messange("Выберете станцию для добавления", true)]
    route.add_station(station) if @stations[station]
  end
  #Метод для удаления станции из маршрута
  def del_station_in_route
    puts "Список станций маршрута #{route.name}"
    route.show_stations
    route.delete_station[show_messange("Выберете станцию для удаления"), true]
    puts "Станция успешно удалена!"
  end
  #Метод для создания маршрута
  def create_route
    if @stations.size > 2
      puts "============Создание нового маршрута============"
      name = show_messange("Введите имя маршрута")
      puts "Доступные станции для добавления:"
      show_stations
      first_station = @stations[show_messange("Выберете начальную станцию", true)]
      last_station = @stations[show_messange("Выберете конечную станцию", true)]
      @routes << route = Route.new(name, first_station, last_station)
      puts "Маршрут #{name} успешно создан #{route.show_stations}"
    else
      puts "Необходимо больше 2-х станций для создание маршрута"
    end
  end
  #Метод для ввывода сообщения и возврата переменной, ввёдной пользователем
  def show_messange(messange, int = false)
    print "#{messange}\n"
    input = gets.chomp
    return nil if input == nil
    int ? input.to_i : input
  end
#Назначать маршрут поезду
  def assign_route
    puts "============Назначение маршрута поезду============"
    show_train
    train = @trains[show_messange("Выберете поезд"),true]
    if @trains[train]
      puts "Список маршрутов:\n"
      show_route
      route = @routes[show_messange("Выберете маршрут",true)]
      if @routes[route]
        train.set_route(route) if @routes[route]
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
  train = @trains[show_messange("Выберете поезд для перемещения", true)]
    if train
    loop do
      puts "Поезд #{train.nubmer} находится на станции #{train.current_station}"
      puts "[n] - для перемещения на следующую станцию"
      puts "[p] - для перемещения на предыдущую станцию"
      action = show_messange("")
      break if action == nil
        if action == "n"
          train.move_forward
        elsif action == "p"
          train.move_backward
        end
      end
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
