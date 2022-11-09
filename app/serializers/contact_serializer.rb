class ContactSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :birthdate, :address, :phones, :kind

  def attributes(*args)
    hash = super(*args)
    hash[:birthdate] = object.birthdate.to_time.iso8601
    hash
  end
end
