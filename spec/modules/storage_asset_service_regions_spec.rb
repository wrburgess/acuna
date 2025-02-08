require 'rails_helper'

RSpec.describe StorageAssetServiceRegions, type: :module do
  describe '.all' do
    it 'returns all region codes from both AWS and Azure' do
      expected_result = %w[
        us-east-1
        us-east-2
        us-west-1
        us-west-2
        eastus
        eastus2
        centralus
        northcentralus
        southcentralus
        westus
        westus2
        westus3
      ].sort
      expect(StorageAssetServiceRegions.all.sort).to eq(expected_result)
    end
  end

  describe '.options_for_select' do
    it 'returns region codes for options_for_select from both AWS and Azure' do
      expected_result = [
        ['Us East 1', 'us-east-1'],
        ['Us East 2', 'us-east-2'],
        ['Us West 1', 'us-west-1'],
        ['Us West 2', 'us-west-2'],
        ['Eastus', 'eastus'],
        ['Eastus2', 'eastus2'],
        ['Centralus', 'centralus'],
        ['Northcentralus', 'northcentralus'],
        ['Southcentralus', 'southcentralus'],
        ['Westus', 'westus'],
        ['Westus2', 'westus2'],
        ['Westus3', 'westus3']
      ].sort_by { |region| region[1] }
      expect(StorageAssetServiceRegions.options_for_select.sort_by { |region| region[1] }).to eq(expected_result)
    end
  end
end
