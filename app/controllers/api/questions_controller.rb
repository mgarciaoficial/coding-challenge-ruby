# frozen_string_literal: true

class Api::QuestionsController < Api::ApplicationController
  before_action :init_questions

  def index
    render json: {
      data: {
        questions: Questions::JsonPresenter.call(@questions)
      }
    }, status: :ok
  end

  private

  def init_questions
    @questions = Question.shareable
  end
end