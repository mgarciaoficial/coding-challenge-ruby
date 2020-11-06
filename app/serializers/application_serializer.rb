# frozen_string_literal: true

class ApplicationSerializer
  def self.serialize(*args, &block)
    new(*args, &block).serialize
  end
end