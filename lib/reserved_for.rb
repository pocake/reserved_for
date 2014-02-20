require "reserved_for/version"

module ReservedFor
  module ModuleMethods
    def clear_all!
      @reserved_list_map = { whitelist: Set.new }
    end

    def reset!
      clear_all!
      @reserved_list_map[:usernames] = default_usernames
    end

    def configure(&block)
      require 'pry'; binding.pry
    end

    def options
      {}
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

  private

    def default_usernames
      Set.new(File.open("config/USERNAMES").read.split("\n"))
    end
  end

  extend ModuleMethods
  reset!
end
