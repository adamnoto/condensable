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
end
