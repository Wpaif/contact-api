class Kind < ApplicationRecord
  has_many :contacts
  validates :description, presence: true, allow_nil: false
end
