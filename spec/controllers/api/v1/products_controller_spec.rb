require 'rails_helper'

describe Api::V1::ProductsController, type: :controller do
  describe 'GET show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:product) { Product.create!(title: 'Product 42', price: 100, user: user) }

    it 'returns product information' do
      get :show, id: product.id

      res = JSON.parse(response.body)
      expect(res['title']).to eq 'Product 42'
      expect(response.status).to eq 200
    end
  end
end
