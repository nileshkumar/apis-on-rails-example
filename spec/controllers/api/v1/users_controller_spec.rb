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
end
