require 'rails_helper'

describe User, type: :model do
  describe 'associations' do
    it 'deletes associated products on destroy' do
      user = FactoryGirl.create(:user)
      3.times { |i| user.products.create(title: "Test product #{i}", price: 10) }

      product_ids = user.product_ids
      user.destroy

      product_ids.each do |id|
        expect { Product.find(id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#generate_authentication_token!' do
    let(:user) { FactoryGirl.build(:user) }

    it 'sets a unique token' do
      expect(Devise).to receive(:friendly_token).and_return('auniquetoken')
      user.generate_authentication_token!
      expect(user.auth_token).to eq 'auniquetoken'
    end
  end
end
