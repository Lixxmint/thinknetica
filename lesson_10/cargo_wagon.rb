require_relative 'wagon'

class CargoWagon < Wagon

  attr_reader :volume, :occupied_volume

  validate :volume, :presence

  def initialize(volume)
    type = :cargo
    @volume = volume
    @occupied_volume = 0.0
    validate!
  end

  def fill(volume)
    @occupied_volume += volume unless volume_free - volume < 0
  end

  def volume_free
    @volume - @occupied_volume
  end

  def wagon_info
    puts "Тип: #{@type}\nСвободный объём: #{volume_free}\nЗанятый объём: #{@occupied_volume}"
  end
end
