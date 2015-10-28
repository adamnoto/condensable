require 'spec_helper'

class OrderParams
  include Condensable
end

describe Condensable do
  it 'has a version number' do
    expect(Condensable::VERSION).not_to be nil
  end

  let(:order_params) { OrderParams.new }

  describe OrderParams do
    it "includes Condensable" do
      OrderParams.include?(Condensable)
    end

    it "includes Condensable::GravityAbsorber" do
      OrderParams.include?(Condensable::GravityAbsorber)
    end

    it "can make new variable on the fly" do
      expect { order_params.order_id = 1 }.not_to raise_error()

      expect(order_params.respond_to?(:order_id=)).to be_truthy
      expect(order_params.respond_to?(:order_id)).to be_truthy
      expect(order_params.order_id).to eq(1)
    end

    context "with condensed values" do
      before do
        order_params.order_id = "ABC-1234"
        order_params.delivery = "Jl HR. Rasuna Said 23"
        order_params.name = "Adam Pahlevi"
        order_params.city = "Jakarta"
      end

      it "can respond to keys and return all condensed keys" do
        expect(order_params.condensed_variables).to eq([:order_id, :delivery, :name, :city])
      end

      it "can respond to values and return all condensed values" do
        expect(order_params.condensed_values).to eq(["ABC-1234", "Jl HR. Rasuna Said 23", "Adam Pahlevi", "Jakarta"])
      end

      it "can respond to each" do
        expect(order_params.respond_to?(:each)).to be_truthy
        each_vars = {}
        order_params.each do |key, value|
          each_vars[key] = value
        end
        expect(each_vars).to eq({:order_id=>"ABC-1234", :delivery=>"Jl HR. Rasuna Said 23", :name=>"Adam Pahlevi", :city=>"Jakarta"})
      end

      it "can tell whether a variable is a result of condensation or not" do
        expect(order_params.is_condensed?(:order_id)).to be_truthy
        expect(order_params.is_condensed?(:name)).to be_truthy
        expect(order_params.is_condensed?(:delivery)).to be_truthy
        expect(order_params.is_condensed?(:city)).to be_truthy
        expect(order_params.is_condensed?(:address)).to be_falsey
      end
    end

    it "can re-assign variable value" do
      order_params.order_id = 1
      expect(order_params.order_id).to eq(1)
      order_params.order_id = "BC23-19238-29910299"
      expect(order_params.order_id).to eq("BC23-19238-29910299")
    end
  end

  context "create on-the-fly condensable class" do
    it "can behave normally" do
      condensable_my_data = Condensable.new
      my_data = condensable_my_data.new

      expect(my_data.name).to be_nil
      expect(my_data.respond_to?(:name)).to be_falsey
      my_data.name = 'Adam Pahlevi'
      expect(my_data.name).to eq('Adam Pahlevi')
      expect(my_data.respond_to?(:name)).to be_truthy
    end

    it 'can accept block and define with ruby normal class DSL' do
      my_data = Condensable.new do
        def full_name
          "#{first_name} #{last_name}"
        end
      end.new

      expect(my_data.full_name).to eq(' ')
      my_data.first_name = 'Adam'
      my_data.last_name = 'Pahlevi'
      expect(my_data.full_name).to eq('Adam Pahlevi')
    end

    context 'with default options' do
      it 'can return default string' do
        # creating an on-the-fly class, and initialize that class
        my_data = Condensable.new(default: 'not-available').new
        expect(my_data.order_id).to eq('not-available')
      end

      it 'can return nil' do
        my_data = Condensable.new(default: nil).new
        expect(my_data.order_id).to be_nil
      end

      it 'can by default raise error' do
        my_data = Condensable.new(default: :raise_error)
        expect { my_data.launch_rocket }.to raise_error(NoMethodError)
      end

      it 'can execute method' do
        my_data = Condensable.new(default: :execute_method) do
          def execute_method
            "HI THERE"
          end
        end.new

        expect(my_data.hi_in_english).to eq('HI THERE')
        expect(my_data.hi_in_american).to eq('HI THERE')
      end
    end
  end

  context "with default behaviour" do
    context "if unspecified" do
      it "returns nil" do
        expect(order_params.adam).to eq(nil)
      end
    end

    context "if set to returns a astring" do
      it "returns string" do
        class OrderParamsReturnStringC
          include Condensable
          condensable default: "adam"
        end

        op = OrderParamsReturnStringC.new
        expect(op.name).to eq("adam")
      end
    end

    context "if set to execute method" do
      it "executes a method" do
        class OrderParamsExecMethod
          include Condensable
          condensable default: :execute_me

          def execute_me
            "adam pahlevi"
          end
        end

        opem = OrderParamsExecMethod.new
        expect(opem.name).to eq("adam pahlevi")
      end

      it "executes a method with params" do
        class OrderParamsExecMethodParams
          include Condensable
          condensable default: :execute_me

          def execute_me(name, *args)
            [name] + args
          end
        end

        opemp = OrderParamsExecMethodParams.new
        expect(opemp.name("adam")).to eq([:name, "adam"])
        expect(opemp.age).to eq([:age])
        expect(opemp.whatever("adam", "pahlevi")).to eq([:whatever, "adam", "pahlevi"])
      end
    end

    context "if set to raise an error" do
      it "raises an error" do
        class OrderParamsRaiseError
          include Condensable
          condensable default: :raise_error
        end

        opre = OrderParamsRaiseError.new
        expect { opre.name }.to raise_error(NoMethodError)
      end
    end
  end
end
