# frozen_string_literal: true

class ApplicationPresenter
  def self.call(*args, &block)
    new(*args, &block).call
  end
end