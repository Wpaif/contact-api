class Contact < ApplicationRecord
  belongs_to :kind
  has_many :phones
  has_one :address

  accepts_nested_attributes_for :phones, allow_destroy: true
  accepts_nested_attributes_for :address, allow_destroy: true

  validates :name, :email, :birthdate, presence: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: true
  validates :birthdate, comparison: { less_than_or_equal_to: Time.zone.today - 18.years }

  def as_json(options = {})
    hash = super(options)
    hash[:birthdate] = I18n.l(birthdate)
    hash
  end
end
