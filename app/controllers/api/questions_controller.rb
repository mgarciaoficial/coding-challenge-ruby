# frozen_string_literal: true

class Api::QuestionsController < Api::ApplicationController
  before_action :init_questions

  def index
    render json: {
      data: {
        questions: @questions.as_json
      }
    }, status: :ok
  end

  private

  def init_questions
    @questions = Question.shareable
  end
end