require "reserved_for/version"

module ReservedFor
  module ModuleMethods
    def clear_all!
      @reserved_list_map = { whitelist: Set.new }
    end

    def any(whitelist: true)
      set  = @reserved_list_map.values.inject(:+)
      set -= @reserved_list_map[:whitelist] if whitelist
      set
    end

    def method_missing(name, *args)
      case name.to_s
      when /(.*)=$/
        @reserved_list_map[$1.to_sym] = Set.new(args.flatten)
      else
        @reserved_list_map[name.to_sym]
      end
    end
  end

  extend ModuleMethods
  clear_all!
end
