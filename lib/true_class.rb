# frozen_string_literal: true

class TrueClass
  def to_s
    Sail::ConstantCollection::TRUE
  end
end
