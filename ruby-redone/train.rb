require_relative 'company_module'
require_relative 'instance_counter'

class Train
  include InstanceCounter
  include NameCompany

  attr_reader :number, :type, :wagons, :speed, :route

  @@trains = {}
  def self.find(number)
    @@trains[number]
  end

   def initialize(number, type = :passenger)
     @number = number
     @type = type
     @speed = 0
     @wagons = []
     @route = nil
     @station_index = nil
     @@trains[number] = self
     register_instance
   end

   def current_station
     return unless @route
    @route.show_route[@station_index]
  end

  def train_info
  #  if @route
    #  puts "==> Поезд #{:number}\nТип:#{@type}\nМаршрут: #{@route.name}\nКол-во вагонов: #{@wagons.size}"
  #  else
      puts "==> Поезд #{:number}\nТип:#{@type}\nКол-во вагонов: #{@wagons.size}"
  #  end
  end

   def speed_up
     @speed > 120 ? 120 : @speed +=10
   end

   def speed_down
     @speed < 0 ? 0 : @speed -=10
   end

   def stop
     @speed = 0
   end

   def attach_wagon(wag)
     unless moving?
       @wagons << wag
     end
   end

   def detach_wagon
     unless moving?
       @wagons.delete_at(-1)
     end
   end

   def set_route(r)
     @route = r
     @station_index = 0
     current_station.add_train(self)
   end

   def move_forward
     return unless @route && next_station
     current_station.del_train(self)
     @station_index += 1
     current_station.add_train(self)
   end

   def move_back
     return unless @route && prev_station
     current_station.del_train(self)
     @station_index -=1
     current_station.add_train(self)
   end

   def prev_station
    return unless @route
    get_station_by_index @station_index - 1
   end

   def next_station
     return unless @route
     get_station_by_index @station_index + 1
   end

   def current_station
     return unless @route
    get_station_by_index @station_index
   end

   def moving?
     @speed !=0
   end

   protected

   def get_station_by_index(index)
     return nil if index <0
     @route.stations[index]
   end
end
