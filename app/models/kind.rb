class Kind < ApplicationRecord
  validates :description, presence: true, allow_nil: false
end
