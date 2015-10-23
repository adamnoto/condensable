require "blackhole/version"
require "blackhole/gravity_absorber"

module Blackhole
  def self.included(base)
    base.include(Blackhole::GravityAbsorber)
  end
end
