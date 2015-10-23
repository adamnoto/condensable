module Blackhole
  # handle when an instance variable is not defined, absorber will create one
  # on the fly
  module GravityAbsorber
    def method_missing(method_name, *args, &block)
      if method_name.to_s[-1] == '='
        # get proper attribute name, by removing "="
        attribute_name = method_name[0..-2]
        instance_eval do
          eval %Q{
            def #{attribute_name}=(arg)
              @#{attribute_name} = arg
            end
            def #{attribute_name}
              @#{attribute_name}
            end
          }
        end # instance eval

        send(method_name, *args)
      else
        blackhole_missing_attribute(method_name, *args)
      end
    end # method missing

    # configuration block
    def blackhole options
      if options[:default]
        blackhole_handle_default options[:default]
      end
    end

    # what happen if method is missing?
    def blackhole_handle_default arg
      @blackhole_handle_default = arg
    end

    def blackhole_missing_attribute(method_name, *args)
      if @blackhole_handle_default == :raise_error
        raise NoMethodError, "#{method_name} is undefined"
      elsif @blackhole_handle_default == nil
        return nil
      elsif @blackhole_handle_default.is_a?(Symbol)
        send(@blackhole_handle_default, *args)
      elsif @blackhole_handle_default.is_a?(String)
        return @blackhole_handle_default
      end
    end
  end
end
