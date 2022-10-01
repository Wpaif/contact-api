require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#invalid?' do
    context 'without presence' do
      it 'street' do
        address = build :address, street: nil

        expect(address.invalid?).to be true
      end

      it 'city' do
        address = build :address, city: nil

        expect(address.invalid?).to be true
      end
    end
  end
end
