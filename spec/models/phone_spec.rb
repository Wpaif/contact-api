require 'rails_helper'

RSpec.describe Phone, type: :model do
  describe '#invalid?' do
    context 'with number' do
      it 'format' do
        phone = build :phone, number: '(89)999192'

        expect(phone.invalid?).to be true
      end

      it 'presence' do
        phone = build :phone, number: nil

        expect(phone.invalid?).to be true
      end

      it 'uniqueness' do
        create :phone, number: '(99) 9999-9999'
        phone = build :phone, number: '(99) 9999-9999'

        expect(phone.invalid?).to be true
      end
    end
  end
end
