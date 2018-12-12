class Station
  attr_reader :all_train, :name

  def initialize(name)
    @name = name
    @all_train = []
  end
  def add_train(train)
    @all_train << train
  end
  def trains_by_type(type)
    @all_train.select { |train| train.type == type }
  end
  def move_train(train)
    @trains.delete train
  end
end
 
