require 'rails_helper'

describe StorageAssetServices, type: :module do
  it 'renders a type' do
    expect(described_class::AZURE).to eq('azure')
    expect(described_class::DROPBOX).to eq('dropbox')
    expect(described_class::S3).to eq('s3')
    expect(described_class::SHAREPOINT).to eq('sharepoint')
  end

  describe '.options_for_select' do
    it 'returns a list of types' do
      expect(described_class.options_for_select).to include(%w[Azure azure], %w[Dropbox dropbox], %w[S3 s3], %w[Sharepoint sharepoint])
    end
  end

  context '.all' do
    it 'returns a list of all types' do
      expect(described_class.all).to include('azure', 'dropbox', 's3', 'sharepoint')
    end
  end
end
