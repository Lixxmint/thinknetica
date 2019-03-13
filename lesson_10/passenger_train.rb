require_relative 'train'

class PassengerTrain < Train

  validate :number, :presence
  validate :number, :format, /^\w{3}-?\w{2}$/

  def initialize(number)
    super(number, :passenger)
  end
end
