class Phone < ApplicationRecord
  belongs_to :contact

  validates :number, presence: true
  validates :number, uniqueness: true
  validates :number, format: { with: /\([1-9]{2}\) ?(?:[2-8]|9?[0-9])[0-9]{3}-[0-9]{4}/ }
end
