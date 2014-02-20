require 'reserved_for'

class String
  def reserved_for?
    require 'pry'; binding.pry
  end
end