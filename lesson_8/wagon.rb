require_relative 'company_module'
require_relative 'validation'

class Wagon
  include NameCompany
  include Validation

  WAGON_TYPES = %i[cargo passenger].freeze

  attr_reader :type

  def initialize(type)
    @type = type
    validate!
  end
=begin
  def wagon_info
    if @type = :cargo
      puts "Тип: #{@type}\nСвободный объём: #{@value_free}\nЗанятый объём: #{@occupied_volume}"
    else
      puts "Тип: #{@type}\nКол-во свободных мест: #{@seats_free}\nКол-во занятых мест: #{@occupied_seat}"
    end
  end
=end
  protected

  def validate!
    unless WAGON_TYPES.include?(@type)
      raise ArgumentError, 'Неправильный тип вагона'
    end
  end
end
