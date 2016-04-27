require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  before do
    request.headers['Accept'] = 'application/vnd.marketplace.v1'
  end

  describe 'GET #show' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns user json' do
      get :show, id: user.id, format: :json
      response_hash = JSON.parse(response.body)

      expect(response_hash['email']).to eq user.email
      expect(response.status).to eq 200
    end
  end

  describe 'POST #create' do
    let(:attrs) { FactoryGirl.attributes_for(:user) }
    let(:invalid_attrs) { { password: '12345678', password_confirmation: '12345678' } }

    it 'renders the created user' do
      post :create, user: attrs, format: :json
      response_hash = JSON.parse(response.body)

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

    it 'renders the updated user' do
      patch :update, id: user.id, user: { email: 'newmail@example.com' }, format: :json
      response_hash = JSON.parse(response.body)

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
      delete :destroy, id: user.id, format: :json
      expect(response.status).to be 204
    end
  end
end
