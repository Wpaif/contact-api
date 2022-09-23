require 'rails_helper'

RSpec.describe Kind, type: :model do
  describe '#invalid?' do
    context 'without presence' do
      it 'description' do
        kind = build :kind, description: nil

        expect(kind.invalid?).to be true
      end
    end
  end
end
