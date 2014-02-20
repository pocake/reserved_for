require 'reserved_for'

module ReservedFor
  module MethodMissing
    def method_missing(name, *args)
      if name.to_s =~ /^reserved_for_(.*)\?$/
        ReservedFor.public_send($1.to_sym).include?(self)
      else
        super
      end
    end
  end
end

class String
  def reserved_for_any?
    ReservedFor.any.include?(self)
  end
  alias :reserved_for? :reserved_for_any?

  prepend ReservedFor::MethodMissing
end