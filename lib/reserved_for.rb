require "reserved_for/version"

module ReservedFor
  module ModuleMethods
    def clear_all!
      @reserved_list_map = {}
      @white_list        = Set.new
    end

    def method_missing(name, *args)
      case name.to_s
      when /(.*)=$/
        @reserved_list_map[$1.to_sym] = Set.new(args.flatten)
      else
        @reserved_list_map[name.to_sym] || Set.new
      end
    end
  end

  extend ModuleMethods
  clear_all!
end
