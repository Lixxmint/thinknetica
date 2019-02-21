module TrainMenu
  private

  def show_menu_trains
    puts "\nУправление поездами:\n
    [1] Создать поезд
    [2] Установить маршрут поезду
    [3] Прицепить вагон поезду
    [4] Отцепить вагон от поезда
    [5] Двигать поезд
    [6] Управление вагонами
    [0] Выход"
    puts '=========================================================='
  end

  def manage_trains
    case gets.chomp
    when '1' then create_trains
    when '2' then route_set
    when '3' then add_wagon
    when '4' then del_wagon
    when '5' then move_train
    when '6' then manage_wagon
    else
      break
    end
  end

  def create_trains
    puts "\nВыберете тип поезда:\n
    [1] Пассажирский
    [2] Товарный
    [0] Выход"
    puts '=========================================================='

    case gets.chomp
    when '1' then type = :passenger
    when '2' then type = :cargo
    else
      return
    end
    number = ask('Введите номер поезда')
    train = type == :passenger ? PassengerTrain.new(number) : CargoTrain.new(number)
    @trains << train
    puts 'Объект создан'
    train.train_info
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def route_set
    puts '============Назначить маршрут поезду============'
    show_route
    route_index = ask('Выберете маршрут', true)
    if @routes[route_index]
      route = @routes[route_index]
      show_train
      train_index = ask('Выберете поезд, которому назначить маршрут', true)
      if @trains[train_index]
        train = @trains[train_index]
        train.route_set(route)
        puts 'Маршрут назначен'
      else
        puts 'Нет такого поезда'
      end
    else
      puts 'Нет такого маршрута'
    end
  end

  def move_train
    puts '======Переместить поезд======'
    show_train
    train = @trains[ask('Выберете поезд', true)]
    if train.route.nil?
      puts 'У поезда нет маршрута'
      return
    else
      train.train_info
      puts "\nВыберете действие:\n
      [1] Переместить вперед
      [2] Переместить назад
      [0] Выход"
      puts '============================='

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
    puts 'Поезд перемещён вперёд'
  end

  def move_backward(train)
    train.move_backward
    puts 'Поезд перемещён назад'
  end

  def show_train
    @trains.each_with_index do |train, index|
      puts "[#{index}]"
      puts train.train_info.to_s
    end
  end
end
