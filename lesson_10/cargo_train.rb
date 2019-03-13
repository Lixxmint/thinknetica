require_relative 'train'

class CargoTrain < Train

  validate :number, :presence
  validate :number, :format, /^\w{3}-?\w{2}$/

  def initialize(number)
    super(number, :cargo)
  end
end
