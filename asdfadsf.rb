class Contact < ApplicationRecord
  validates :name, :email, :birthdate, presence: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: true
  validates :birthdate, comparison: { less_than_or_equal_to: Time.zone.today - 18.years }
end
