# frozen_string_literal: true

# Patch for Ruby's FalseClass
class FalseClass
  def to_s
    Sail::ConstantCollection::FALSE
  end
end
