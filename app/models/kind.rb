class Kind < ApplicationRecord
  has_many :contacts, dependent: :destroy_async
  validates :description, presence: true
end
