require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  describe 'POST create' do
    let(:user) { FactoryGirl.create(:user) }

    it 'returns the user with auth token' do
      post :create, session: { email: user.email, password: '1234567890' }
      res = JSON.parse(response.body).fetch('user')
      user.reload

      expect(res['auth_token']).to eq user.auth_token
      expect(response.status).to eq 200
    end

    it 'returns error json for incorrect credentials' do
      post :create, session: { email: user.email, password: '1234567' }
      res = JSON.parse(response.body)

      expect(res['message']).to eq 'Invalid email or password'
      expect(response.status).to eq 422
    end
  end

  describe 'DELETE destroy' do
    let(:user) { FactoryGirl.create(:user) }

    it 'responds with 204' do
      delete :destroy, id: user.auth_token
      expect(response.status).to eq 204
    end
  end
end
