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
        expect(order_params.keys).to eq([:order_id, :delivery, :name, :city])
      end

      it "can respond to values and return all condensed values" do
        expect(order_params.values).to eq(["ABC-1234", "Jl HR. Rasuna Said 23", "Adam Pahlevi", "Jakarta"])
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
