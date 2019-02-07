require_relative 'company_module'
require_relative 'instance_counter'
require_relative 'validation'

class Train
  include InstanceCounter
  include NameCompany
  include Validation

  TRAIN_NUMBER_FORMAT = /^\w{3}-?\w{2}$/.freeze
  TRAIN_TYPES = %i[cargo passenger].freeze

  attr_reader :number, :type, :wagons, :speed, :route

  @@trains = []
  def self.find(number)
    @@trains.find { |x| return x if x.number == number }
  end

   def initialize(number, type)
     @number = number.to_s
     @type = type
     validate!
     @speed = 0
     @wagons = []
     @route = nil
     @station_index = nil
     @@trains << self
     register_instance
   end

  def train_info
    if @route
      puts "Поезд #{@number}\nТип:#{@type}\nМаршрут: #{@route.name}\nТекущая станция: #{current_station.name}\nКол-во вагонов: #{@wagons.size}\n"
    else
      puts "Поезд #{@number}\nТип:#{@type}\nКол-во вагонов: #{@wagons.size}\n"
    end
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

   def move_backward
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

   def validate!
     unless TRAIN_TYPES.include?(@type)
       raise ArgumentError, 'Неправильный тип поезда'
     end

     unless @number =~ TRAIN_NUMBER_FORMAT
       raise ArgumentError, 'Неправильный номер вагона: XXX(-XX)'
    end
  end
end
