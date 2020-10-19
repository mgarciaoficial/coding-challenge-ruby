class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers,   dependent: :destroy

  validates_presence_of :name
end
