class Contact < ApplicationRecord
  belongs_to :kind

  validates :name, :email, :birthdate, presence: true, allow_nil: false
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: true
  validates :birthdate, comparison: { less_than_or_equal_to: Time.zone.today - 18.years }
end
