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

  describe 'Scopes' do
    before do
      @product1 = FactoryGirl.create :product, user: user, title: "A plasma TV", price: 150
      @product2 = FactoryGirl.create :product, user: user, title: "Fastest Laptop", price: 50
      @product3 = FactoryGirl.create :product, user: user, title: "CD player", price: 100
      @product4 = FactoryGirl.create :product, user: user, title: "LCD TV", price: 99
    end

    let(:user) { FactoryGirl.create(:user) }

    describe '.filter_by_title' do
      it 'returns 2 results matching TV' do
        results = Product.filter_by_title('TV')

        expect(results.size).to eq 2
        expect(results).to include @product1, @product4
      end
    end

    describe '.above_or_equal_to_price' do
      it 'returns two results' do
        results = Product.above_or_equal_to_price(100)
        expect(results.size).to eq 2
        expect(results).to include @product1, @product3
      end
    end

    describe '.below_or_equal_to_price' do
      it 'returns 2 results' do
        results = Product.below_or_equal_to_price(99)
        expect(results.size).to eq 2
        expect(results).to include @product2, @product4
      end
    end

    describe '.recent' do
      it 'sorts by most recently updated' do
        @product2.touch
        @product3.touch

        results = Product.recent

        expect(results).to match_array([@product3, @product2, @product4, @product1])
      end
    end

    describe '.search' do
      context "when title 'LCD' and '100' a min price are set" do
        it "returns an empty array" do
          search_hash = { keyword: "LCD", min_price: 100 }
          expect(Product.search(search_hash)).to be_empty
        end
      end

      context "when title 'tv', '150' as max price, and '100' as min price are set" do
        it "returns the product1" do
          search_hash = { keyword: "tv", min_price: 100, max_price: 150 }
          expect(Product.search(search_hash)).to match_array([@product1])
        end
      end

      context "when an empty hash is sent" do
        it "returns all the products" do
          expect(Product.search({})).to match_array([@product1, @product2, @product3, @product4])
        end
      end

      context "when product_ids is present" do
        it "returns the product from the ids" do
          search_hash = { product_ids: [@product1.id, @product2.id]}
          expect(Product.search(search_hash)).to match_array([@product1, @product2])
        end
      end
    end
  end
end
