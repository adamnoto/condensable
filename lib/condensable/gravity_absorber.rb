module Condensable
  # handle when an instance variable is not defined, absorber will create one
  # on the fly
  module GravityAbsorber
    def included(base)
      base.extend(GravityAbsorber::ClassLevelMethods)
    end

    # list all condensed variables
    def condensed_variables
      @condensed_variables = [] if @condensed_variables.nil?
      @condensed_variables 
    end

    # check whether a variable is a result of condensation
    def is_condensed?(variable_name)
      @condensed_variables.include?(variable_name.to_sym)
    end

    # all condensed variables' name
    def keys
      condensed_variables
    end

    # all condensed variables' value
    def values
      values = []
      condensed_variables.each do |var|
        values << send(var)
      end
      values
    end
    def method_missing(method_name, *args, &block)
      if method_name.to_s[-1] == '='
        # get proper attribute name, by removing "="
        attribute_name = method_name[0..-2]
        setter_name = "#{attribute_name}="
        getter_name = attribute_name

        unless respond_to?(setter_name)
          instance_eval do
            eval %Q{
              def #{attribute_name}=(arg)
                @#{attribute_name} = arg
              end
            }
          end
        end

        unless respond_to?(getter_name)
          instance_eval do
            eval %Q{
              def #{attribute_name}
                @#{attribute_name}
              end
            }
          end # instance eval
        end

        send(setter_name, *args)
      else
        condensable_missing_attribute(method_name, *args)
      end
    end # method missing

    def condensable_missing_attribute(method_name, *args)
      default_handle_arg = Condensable::DEFAULT_VALUES[self.class.to_s]

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
