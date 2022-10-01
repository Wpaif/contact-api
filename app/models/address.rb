class Address < ApplicationRecord
  belongs_to :contact

  validates :street, :city, presence: true
end
