require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET index' do
    it 'returns all the product records' do
      2.times { |i| Product.create(title: "Product #{i}", price: 200, user: user) }
      get :index

      products = JSON.parse(response.body).fetch('products')
      expect(products.length).to be 2
      expect(response.status).to eq 200

      first_product = products.fetch(0)
      user_json = first_product.fetch('user')
      expect(user_json['email']).to eq user.email
    end
  end

  describe 'GET show' do
    let(:product) { Product.create!(title: 'Product 42', price: 100, user: user) }

    it 'returns product information' do
      get :show, id: product.id

      res = JSON.parse(response.body).fetch('product')
      expect(res['title']).to eq 'Product 42'
      expect(response.status).to eq 200

      user_json = res.fetch('user')
      expect(user_json['email']).to eq user.email
    end
  end
end
