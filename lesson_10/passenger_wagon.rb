require_relative 'wagon'

class PassengerWagon < Wagon

  attr_reader :seats, :occupied_seat

  validate :seats, :presence

  def initialize(seats)
    @seats = seats
    @type = :passenger
    @occupied_seat = 0
    validate!
  end

  def take_seat
    @occupied_seat += 1 unless seats_free.zero?
  end

  def seats_free
    @seats - @occupied_seat
  end

  def wagon_info
    puts "Тип: #{@type}\nКол-во свободных мест: #{seats_free}\nКол-во занятых мест: #{@occupied_seat}"
  end
end
