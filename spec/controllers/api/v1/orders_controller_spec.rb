require 'rails_helper'

describe Api::V1::OrdersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  before { request.headers['Authorization'] = user.auth_token }

  describe "GET #index" do
    before(:each) do
      4.times { Order.create!(user: user, total: 100) }
    end

    it "returns 4 order records from the user" do
      get :index, user_id: user.id, format: :json

      orders_response = JSON.parse(response.body).fetch('orders')

      expect(orders_response.size).to eq 4
      expect(response.status).to eq 200
    end
  end

  describe 'GET show' do
    it 'returns the matching order' do
      order = Order.create!(user: user, total: 100)
      get :show, user_id: user.id, id: order.id, format: :json

      order_json = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(order_json['id']).to eq order.id
    end
  end
end
