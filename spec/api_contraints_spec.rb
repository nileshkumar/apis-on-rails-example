require 'api_constraints'

describe ApiConstraints do
  let(:v1_constraints) { ApiConstraints.new(version: 1) }
  let(:v2_constraints) { ApiConstraints.new(version: 2, default: true) }

  describe '#matches?' do
    it 'matches version from Accept headers' do
      request = double(headers: { 'Accept' => 'application/vnd.marketplace.v1' })
      expect(v1_constraints.matches?(request)).to be_truthy
    end

    it 'matches default version when not specified' do
      request = double('request')
      expect(v2_constraints.matches?(request)).to be_truthy
    end
  end
end
