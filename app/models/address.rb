class Address < ApplicationRecord
  belongs_to :contact

  validates :street, :city, presence: true, allow_nil: false
end
