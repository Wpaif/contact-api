class Contact < ApplicationRecord
  belongs_to :kind
  has_many :phones

  validates :name, :email, :birthdate, presence: true
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: true
  validates :birthdate, comparison: { less_than_or_equal_to: Time.zone.today - 18.years }

  def as_json(*)
    super include: { kind: { except: %i[created_at updated_at id] } },
          except: %i[created_at updated_at kind_id id]
  end
end
