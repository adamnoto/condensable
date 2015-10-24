require "condensable/version"
require "condensable/gravity_absorber"
require "condensable/gravity_absorber/class_level_methods"

module Condensable
  # map class with default values
  DEFAULT_VALUES = {}

  def self.included(base)
    base.include(Condensable::GravityAbsorber)
    base.extend(Condensable::GravityAbsorber::ClassLevelMethods)
  end
end
