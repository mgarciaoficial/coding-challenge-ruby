# frozen_string_literal: true

module Questions
  class JsonPresenter < ApplicationPresenter
    attr_reader :serializable

    def initialize(serializable)
      @serializable = serializable
    end

    def call
      serializable.as_json(
        only: %i[id title created_at updated_at],
        include: {
          user: {
            only: %i[id name]
          },
          answers: {
            only: %i[id body created_at updated_at],
            include: {
              user: {
                only: %i[id name]
              }
            }
          }
        }
      )
    end

  end
end
