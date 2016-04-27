require 'rails_helper'

describe User, type: :model do
  describe '#generate_authentication_token!' do
    let(:user) { FactoryGirl.build(:user) }

    it 'sets a unique token' do
      expect(Devise).to receive(:friendly_token).and_return('auniquetoken')
      user.generate_authentication_token!
      expect(user.auth_token).to eq 'auniquetoken'
    end
  end
end
