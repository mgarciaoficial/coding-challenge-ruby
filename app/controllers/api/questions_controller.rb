# frozen_string_literal: true

class Api::QuestionsController < Api::ApplicationController
  before_action :init_questions

  def index
    render json: {
      data: {
        questions: Questions::JsonSerializer.serialize(@questions)
      }
    }, status: :ok
  end

  private

  def init_questions
    @questions = Question.shared.where(params.permit(:title, :user_id))
  end
end