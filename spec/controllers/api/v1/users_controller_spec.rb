require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before do
    request.headers['Accept'] = 'application/vnd.marketplace.v1'
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns user json' do
      product = Product.create!(title: 'Test', price: 100, user: user)

      get :show, id: user.id, format: :json
      user_json = JSON.parse(response.body).fetch('user')

      expect(user_json['email']).to eq user.email
      expect(user_json['product_ids']).to include product.id
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    let(:attrs) { FactoryGirl.attributes_for(:user) }
    let(:invalid_attrs) { { password: '12345678', password_confirmation: '12345678' } }

    it 'renders the created user' do
      post :create, user: attrs, format: :json
      response_hash = JSON.parse(response.body).fetch('user')

      expect(response_hash['email']).to eq attrs[:email]
      expect(response.status).to eq 201
    end

    it 'renders error json when user is not created' do
      post :create, user: invalid_attrs, format: :json
      response_hash = JSON.parse(response.body)

      expect(response_hash).to have_key 'errors'
      expect(response_hash['errors']['email']).to include "can't be blank"
    end
  end

  describe 'PATCH update' do
    let(:user) { FactoryGirl.create(:user) }

    before { request.headers['Authorization'] = user.auth_token }

    it 'renders the updated user' do
      patch :update, id: user.id, user: { email: 'newmail@example.com' }, format: :json
      response_hash = JSON.parse(response.body).fetch('user')

      expect(response_hash['email']).to eq 'newmail@example.com'
      expect(response.status).to eq 200
    end

    it 'renders errors for invalid input' do
      patch :update, id: user.id, user: { email: 'newmail' }, format: :json
      response_hash = JSON.parse(response.body)

      expect(response_hash).to have_key 'errors'
      expect(response.status).to eq 422
    end
  end

  describe 'DELETE destroy' do
    let(:user) { FactoryGirl.create(:user) }

    it 'deletes the user' do
      request.headers['Authorization'] = user.auth_token
      delete :destroy, id: user.id, format: :json
      expect(response.status).to be 204
    end

    it 'renders error if not authorized' do
      request.headers['Authorization'] = 'invalid-token'
      delete :destroy, id: user.id, format: :json

      res = JSON.parse(response.body)
      expect(res['errors']).to eq 'Not authenticated'
      expect(response.status).to be 401
    end
  end
end
