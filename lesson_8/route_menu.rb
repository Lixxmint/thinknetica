module RouteMenu
  private

  def manage_route
    puts '======Управление маршрутами======'
    puts "\nВыберете действие:\n
    [1] Создать маршрут
    [2] Редактировать
    [0] Выход"
    puts '=========================================================='

    case gets.chomp
    when '1' then create_route
    when '2' then edit_route
    else
      return
    end
  end

  def create_route
    puts '======Создать маршрут======'
    if @stations.size >= 2
      show_stations
      first = @stations[ask('Выберете начальную станцию', true)]
      last = @stations[ask('Выберете конечную станцию', true)]
      name = ask('Выберете название маршрута')
      @routes << Route.new(name, first, last)
      puts "Маршрут #{name} создан"
    else
      puts 'Должно быть больше 2-х станций для создания маршрута'
    end
  end

  def edit_route
    puts '======Редактировать маршрут======'
    show_route
    route_index = ask('Выберете маршрут', true)
    if @routes[route_index]
      route = @routes[route_index]
      puts "Маршрут => #{route_info(route)}"
      puts "\nВыберете действие:\n
      [1] Добавить станцию
      [2] Удалить станцию
      [0] Выход"
      puts '=========================================================='
      case gets.chomp
      when '1' then add_station_route(route)
      when '2' then del_station_route(route)
      else
        return
      end
    else
      puts '======Редатирование маршрута======'
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
