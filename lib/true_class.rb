# frozen_string_literal: true

# Patch for Ruby's TrueClass
class TrueClass
  def to_s
    Sail::ConstantCollection::TRUE
  end
end
