require 'rails_helper'

RSpec.describe Contact do
  describe '#invalid?' do
    context 'without presence' do
      it 'name' do
        contact = build(:contact, name: nil)

        expect(contact.invalid?).to be true
      end

      it 'email' do
        contact = build(:contact, email: nil)

        expect(contact.invalid?).to be true
      end

      it 'brirthdate' do
        contact = build(:contact, birthdate: nil)

        expect(contact.invalid?).to be true
      end
    end

    context 'with invalid format' do
      it 'email' do
        contact = build(:contact, email: "it's not an email")

        expect(contact.invalid?).to be true
      end
    end

    context 'with double registe' do
      it 'email' do
        create(:contact, email: 'mail@mail.com')
        contact = build(:contact, email: 'mail@mail.com')

        expect(contact.invalid?).to be true
      end
    end

    context 'with invalid birthdate' do
      it 'underage' do
        contact = build(:contact, birthdate: Time.zone.today)

        expect(contact.invalid?).to be true
      end
    end
  end
end
