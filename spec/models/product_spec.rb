require 'rails_helper'

describe Product, type: :model do
  describe 'validations' do
    let(:product) { Product.new }

    it 'validates presence on fields' do
      product.valid?

      expect(product.errors[:title]).to include "can't be blank"
      expect(product.errors[:price]).to include "can't be blank"
      expect(product.errors[:user_id]).to include "can't be blank"
    end

    it 'ensures price >= 0' do
      product.price = -1
      product.valid?

      expect(product.errors[:price]).to include 'must be greater than or equal to 0'
    end
  end
end
