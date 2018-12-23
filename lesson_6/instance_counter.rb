module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :cout_instances

    def instances
      @cout_instances ||= 0
    end
  end

  module InstanceMethods

    protected

    def register_instance
      self.class.cout_instances +=1
    end
  end
end
