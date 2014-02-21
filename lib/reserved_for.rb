require "reserved_for/version"
require 'active_support/inflector'
require 'ostruct'

module ReservedFor
  class InvalidOptionError < StandardError; end
  module ModuleMethods

    def clear_all!
      @reserved_list_map = { whitelist: Set.new }
      self
    end

    def reset!(reset_option: true)
      clear_all!
      @options = nil if reset_option
      if options[:use_default_reserved_list]
        plurals = _default_usernames.map{ |word| ActiveSupport::Inflector.pluralize(word) }
        @reserved_list_map[:usernames] = _default_usernames
        @reserved_list_map[:_plurals_usernames] = Set.new(plurals)
      end
      self
    end

    def configure(options = {}, &block)
      config = OpenStruct.new
      block.call(config)
      @options = _default_config
        .merge(options)
        .merge(Hash[config.each_pair.map{ |k,v| [k, v] }])

      invalid_options = @options.keys - _default_config.keys
      raise ReservedFor::InvalidOptionError, "invalid options: #{invalid_options}" if invalid_options.size > 0
      reset!(reset_option: false)
      self
    end

    def options
      @options ||= _default_config
    end

    def any(whitelist: true)
      set = @reserved_list_map.map{ |k, v|
        next v if options[:check_plural]
        next nil if k =~ /^_plurals_/
        v
      }.compact.inject(:+)
      set -= @reserved_list_map[:whitelist] if whitelist
      set
    end

    def method_missing(name, *args)
      case name.to_s
      when /(.*)=$/
        args    = args.flatten
        plurals = args.map{ |arg| ActiveSupport::Inflector.pluralize(arg) }
        @reserved_list_map[$1.to_sym]               = Set.new(args)
        @reserved_list_map["_plurals_#{$1}".to_sym] = Set.new(plurals)
      else
        set =  @reserved_list_map[name.to_sym]
        return nil unless set
        set += @reserved_list_map["_plurals_#{name.to_s}".to_sym] if options[:check_plural]
        set
      end
    end

  private

    def _default_usernames
      Set.new(File.open("#{__dir__}/../config/USERNAMES").read.split("\n"))
    end

    def _default_config
      {
        use_default_reserved_list: true,
        check_plural:              false,
      }
    end
  end

  extend ModuleMethods
  reset!
end
