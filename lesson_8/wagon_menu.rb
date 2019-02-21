module WagonMenu
  private

  def add_wagon
    puts '======Добавить вагон к поезду======'
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    if train == 'exit'
      return
    elsif train.type == :cargo
      volume = ask('Введите объём для нового вагона(ххх.x)', true)
      train.attach_wagon(CargoWagon.new(volume))
      puts 'Вагон добавлен'
      train.train_info
    elsif train.type == :passenger
      seats = ask('Введите кол-во мест в вагоне(xx)', true)
      train.attach_wagon(PassengerWagon.new(seats))
      puts 'Вагон добавлен'
      train.train_info
    else
      puts 'Неверный тип поезда'
    end
  rescue ArgumentError => e
    puts e.message
    retry
  end

  def del_wagon
    puts '======Отцепить вагон от поезда======'
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    return if train == 'exit'

    train.detach_wagon
    puts 'Вагон отцеплен'
    train.train_info
  end

  def show_wagons(train)
    raise ArgumentError, 'У поезда нет вагонов' if train.wagons.empty?

    i = 0
    train.each_wagon do |wag|
      i += 1
      puts "[#{i}]\n=========\n"
      puts wag.wagon_info.to_s
    end
  rescue ArgumentError => e
    puts e.message
  end

  def manage_wagon
    show_train
    train = @trains[ask('Выберете поезд или введите "exit"', true)]
    return if train == 'exit'

    show_wagons(train)
    wagon = train.wagons[ask('Выберете вагон для использования', true) - 1]
    if wagon.type == :cargo
      volume = ask('Сколько заполнять?', true)
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
end
