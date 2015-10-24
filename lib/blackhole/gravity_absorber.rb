module Blackhole
  # handle when an instance variable is not defined, absorber will create one
  # on the fly
  module GravityAbsorber
    def included(base)
      base.extend(GravityAbsorber::ClassLevelMethods)
    end

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

    def blackhole_missing_attribute(method_name, *args)
      default_handle_arg = Blackhole::DEFAULT_VALUES[self.class.to_s]

      if default_handle_arg == :raise_error
        raise NoMethodError, "#{method_name} is undefined"
      elsif default_handle_arg == nil
        return nil
      elsif default_handle_arg.is_a?(Symbol)
        if method(default_handle_arg).arity == 0
          send(default_handle_arg)
        else
          send(default_handle_arg, method_name, *args)
        end
      elsif default_handle_arg.is_a?(String)
        return default_handle_arg
      end
    end
  end
end
