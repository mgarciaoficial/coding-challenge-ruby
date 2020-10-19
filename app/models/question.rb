class Question < ApplicationRecord
  belongs_to :user
  has_many   :answers

  validates_presence_of :title
end
