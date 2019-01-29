require_relative 'train'

class TrainCargo < Train

  def initialize(number)
    super(number, :cargo)
  end
end
