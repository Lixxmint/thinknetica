require_relative 'company_module'
require_relative 'validation'

class Wagon
  include NameCompany
  include Validation

  attr_reader :type_train

  def initialize(type_train)
    @type_train = type_train
    validate!
  end
end
