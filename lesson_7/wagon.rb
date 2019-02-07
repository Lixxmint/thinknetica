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

  protected

  def validate!
    unless WAGON_TYPES.include?(@type)
      raise ArgumentError, 'Неправильный тип вагона'
    end
  end
end
