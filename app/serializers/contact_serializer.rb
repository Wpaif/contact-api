class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :birthdate

  belongs_to :kind do
    link(:related) { kind_url(object.kind.id) }
  end

  has_one :address do
    link(:related) { address_url(object.address.id) }
  end

  has_many :phones

  meta do
    { consultation: Time.zone.now.iso8601 }
  end

  def attributes(*args)
    hash = super(*args)
    hash[:birthdate] = object.birthdate.to_time.iso8601
    hash
  end
end
