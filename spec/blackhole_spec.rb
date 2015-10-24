require 'spec_helper'

class OrderParams
  include Blackhole
end

describe Blackhole do
  it 'has a version number' do
    expect(Blackhole::VERSION).not_to be nil
  end

  let(:order_params) { OrderParams.new }

  describe OrderParams do
    it "includes Blachole" do
      OrderParams.include?(Blackhole)
    end

    it "includes Blackhole::GravityAbsorber" do
      OrderParams.include?(Blackhole::GravityAbsorber)
    end

    it "can make new variable on the fly" do
      expect { order_params.order_id = 1 }.not_to raise_error()

      expect(order_params.respond_to?(:order_id=)).to be_truthy
      expect(order_params.respond_to?(:order_id)).to be_truthy
      expect(order_params.order_id).to eq(1)
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
          include Blackhole
          blackhole default: "adam"
        end

        op = OrderParamsReturnStringC.new
        expect(op.name).to eq("adam")
      end
    end

    context "if set to execute method" do
      it "executes a method" do
        class OrderParamsExecMethod 
          include Blackhole
          blackhole default: :execute_me

          def execute_me
            "adam pahlevi"
          end
        end

        opem = OrderParamsExecMethod.new
        expect(opem.name).to eq("adam pahlevi")
      end

      it "executes a method with params" do
        class OrderParamsExecMethodParams
          include Blackhole
          blackhole default: :execute_me

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
          include Blackhole
          blackhole default: :raise_error
        end

        opre = OrderParamsRaiseError.new
        expect { opre.name }.to raise_error(NoMethodError)
      end
    end
  end
end
