require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'company_module'
require_relative 'route_menu'
require_relative 'station_menu'
require_relative 'train_menu'
require_relative 'wagon_menu'

class Main
  include TrainMenu
  include StationMenu
  include RouteMenu
  include WagonMenu

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
    puts '============Программа по управлению поездами============'
    puts "\nВыберете действие:\n
    [1] Создавать станцию
    [2] Управление поездом
    [3] Управлять маршрутом
    [4] Посмотреть список станций и список поездов на станции
    [0] Выход"
  end

  protected

  def ask(que, int = false)
    puts que + ' '
    input = gets.chomp
    return nil if input.nil?

    int ? input.to_i : input
  end

  def test_date
    # Станции
    @stations << s1 = Station.new('Station1')
    @stations << s2 = Station.new('Station2')
    @stations << s3 = Station.new('Station3')
    @stations << s4 = Station.new('Station4')
    @stations << s5 = Station.new('Station5')
    @stations << s6 = Station.new('Station6')
    # Поезда
    @trains << train1 = PassengerTrain.new('num-01')
    @trains << train2 = PassengerTrain.new('num-02')
    @trains << train3 = PassengerTrain.new('num-03')
    @trains << train4 = CargoTrain.new('num-04')
    @trains << train5 = CargoTrain.new('num-05')
    @trains << train6 = CargoTrain.new('num-06')
    # Маршруты
    @routes << route1 = Route.new('route1', s1, s2)
    @routes << route2 = Route.new('route2', s1, s2)
    @routes << route3 = Route.new('route3', s1, s2)
    # Вагоны
    wagon1 = CargoWagon.new(1200)
    wagon2 = CargoWagon.new(5600)
    wagon3 = CargoWagon.new(3100)
    wagon4 = CargoWagon.new(4200)
    wagon5 = PassengerWagon.new(64)
    wagon6 = PassengerWagon.new(64)
    wagon7 = PassengerWagon.new(32)
    wagon8 = PassengerWagon.new(32)

    train1.route_set(route1)
    train1.attach_wagon(wagon5)
    train1.attach_wagon(wagon6)
    train1.attach_wagon(wagon7)
    train1.attach_wagon(wagon8)
  end
end

Main.new.start
