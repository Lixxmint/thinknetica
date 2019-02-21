require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :volume, :occupied_volume
  def initialize(volume)
    @volume = volume
    @occupied_volume = 0.0
    validate!
    super(:cargo)
  end

  def fill(value)
    if value_free - value < 0
      raise ArgumentError, "Не хватает объёма для заполнения. Объём заполнен #{occupied_volume}/#{volume}"
    end

    @occupied_volume += value
  end

  def value_free
    @volume - @occupied_volume
  end

  def wagon_info
    puts "Тип: #{@type}\nСвободный объём: #{value_free}\nЗанятый объём: #{@occupied_volume}"
  end

  protected

  def validate!
    raise ArgumentError, 'Объём должен быть больше нуля' if @volume <= 0
  end
end
