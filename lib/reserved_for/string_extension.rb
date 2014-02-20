module ReservedFor
  module MethodMissing
    def method_missing(name, *args)
      binding.pry
    end
  end
end

class String
  def reserved_for_any?
  end
  alias :reserved_for? :reserved_for_any?

  prepend ReservedFor::MethodMissing
end