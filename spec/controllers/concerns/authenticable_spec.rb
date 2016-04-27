require 'rails_helper'

class Authentication
  include Authenticable

  def request; end
  def response; end
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  let(:user) { FactoryGirl.create(:user) }

  describe '#current_user' do
    it 'returns user from the Authorization header' do
      request.headers['Authorization'] = user.auth_token
      allow(authentication).to receive(:request)
        .and_return(request)

      expect(authentication.current_user.auth_token).to eq user.auth_token
    end
  end

  describe '#authenticate_with_token' do
    it 'renders json error message' do
      allow(response).to receive(:body)
        .and_return({'errors' => 'Not authenticated'}.to_json)

      allow(authentication).to receive(:response).and_return(response)
      allow(authentication).to receive(:request).and_return(nil)

      res = JSON.parse(response.body)
      expect(res['errors']).to eq 'Not authenticated'
    end
  end
end
