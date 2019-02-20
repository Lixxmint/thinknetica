require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :seat, :occupied_seat

  def initialize(seats)
    @seats = seats
    @occupied_seat = 0
    validate!
    super(:passenger)
  end

  def take_seat
    raise ArgumentError, 'Свободных мест нет' if seats_free.zero?

    @occupied_seat += 1
  end

  def seats_free
    @seats - @occupied_seat
  end

  def wagon_info
    puts "Тип: #{@type}\nКол-во свободных мест: #{seats_free}\nКол-во занятых мест: #{@occupied_seat}"
  end

  protected

  def validate!
    raise ArgumentError, 'Мест в вагоне должно быть больше нуля' if @seats <= 0
  end
end
