require 'rails_helper'

class Authentication
  include Authenticable

  def request; end
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
end
