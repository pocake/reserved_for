require "reserved_for/version"
require 'ostruct'

module ReservedFor
  class InvalidOptionError < StandardError; end
  module ModuleMethods

    def clear_all!
      @reserved_list_map = { whitelist: Set.new }
    end

    def reset!
      clear_all!
      @reserved_list_map[:usernames] = _default_usernames if options[:use_default_reserved_list]
    end

    def configure(options = {}, &block)
      config = OpenStruct.new
      block.call(config)
      @options = _default_config
        .merge(options)
        .merge(Hash[config.each_pair.map{ |k,v| [k, v] }])

      invalid_options = @options.keys - _default_config.keys
      raise ReservedFor::InvalidOptionError, "invalid options: #{invalid_options}" if invalid_options.size > 0
      reset!
      self
    end

    def options
      @options ||= _default_config
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

    def _default_usernames
      Set.new(File.open("config/USERNAMES").read.split("\n"))
    end

    def _default_config
      {
        use_default_reserved_list: true,
        check_plural:              true,
        case_sensitive:            false,
      }
    end
  end

  extend ModuleMethods
  reset!
end
