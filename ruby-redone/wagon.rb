require_relative 'company_module'

class Wagon
  include NameCompany

  attr_reader :type

  def initialize(type)
    @type = type
  end
end
