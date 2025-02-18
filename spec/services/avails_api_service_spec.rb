require 'rails_helper'

RSpec.describe AvailsApiService do
  let(:valid_path) { 'api/v1/titles' }
  let(:auth_token) { 'mock_token_123' }

  let(:mock_credentials) do
    double('env_credentials').tap do |creds|
      allow(creds).to receive(:avails_api_domain).and_return('api.example.com')
      allow(creds).to receive(:avails_api_key).and_return('test_api_key')
      allow(creds).to receive(:avails_secret_key).and_return('test_secret_key')
    end
  end

  let(:credentials_mock) do
    double('credentials').tap do |creds|
      allow(creds).to receive(:[]).with(:test).and_return(mock_credentials)
    end
  end

  before do
    allow(Rails.application).to receive(:credentials).and_return(credentials_mock)

    stub_request(:post, 'https://api.example.com/api/v1/authentication_tokens')
      .with(
        body: {
          api_key: 'test_api_key',
          secret_key: 'test_secret_key'
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
      .to_return(
        status: 200,
        body: { token: auth_token }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe '#initialize' do
    context 'with valid parameters' do
      it 'initializes successfully' do
        expect do
          AvailsApiService.new(path: valid_path)
        end.not_to raise_error
      end
    end

    context 'with invalid HTTP method' do
      it 'raises RequestError' do
        expect do
          AvailsApiService.new(path: valid_path, method: :invalid)
        end.to raise_error(
          AvailsApiService::RequestError,
          /Unsupported HTTP method: invalid. Must be one of: get, post, put, patch, delete/
        )
      end
    end

    context 'with invalid protocol' do
      it 'raises RequestError' do
        expect do
          AvailsApiService.new(path: valid_path, protocol: 'ftp')
        end.to raise_error(AvailsApiService::RequestError, /Unsupported protocol/)
      end
    end
  end

  describe '#request' do
    let(:service) { AvailsApiService.new(path: valid_path) }
    let(:auth_response) do
      {
        token: auth_token,
        exp: 24.hours.from_now.iso8601,
        application_name: 'Test Application'
      }.to_json
    end
    let(:successful_response) do
      {
        data: [{ id: 1, title: 'Movie 1' }]
      }.to_json
    end

    context 'with successful API call' do
      before do
        stub_request(:post, 'https://localhost:8000/api/v1/authentication_tokens')
          .to_return(status: 200, body: auth_response)

        stub_request(:get, "https://localhost:8000/#{valid_path}")
          .with(headers: { 'Authorization' => "Bearer #{auth_token}" })
          .to_return(status: 200, body: successful_response)
      end

      it 'returns successful response with data' do
        response = service.request
        expect(response[:success]).to be true
        expect(response[:token]).to be_present
      end
    end

    context 'with failed authentication' do
      before do
        stub_request(:post, 'https://localhost:8000/api/v1/authentication_tokens')
          .to_return(status: 401, body: '{"error": "Invalid credentials"}')
      end

      it 'raises AuthenticationError' do
        expect do
          service.request
        end.to raise_error(AvailsApiService::AuthenticationError)
      end
    end

    context 'with failed API call' do
      before do
        stub_request(:post, 'https://localhost:8000/api/v1/authentication_tokens')
          .to_return(status: 200, body: auth_response)

        stub_request(:get, "https://localhost:8000/#{valid_path}")
          .to_return(status: 500, body: '{"error": "Internal Server Error"}')
      end

      it 'returns error response' do
        response = service.request
        expect(response[:success]).to be false
        expect(response[:error]).to be_present
      end
    end
  end

  describe 'domain handling' do
    context 'in development' do
      before do
        allow(Rails.env).to receive(:development?).and_return(true)
      end

      it 'uses localhost when no domain provided' do
        service = AvailsApiService.new(path: valid_path)
        expect(service.send(:establish_domain, nil)).to eq('localhost:8000')
      end
    end

    context 'with supplied domain' do
      it 'uses the supplied domain' do
        service = AvailsApiService.new(path: valid_path, domain: 'api.example.com')
        expect(service.send(:establish_domain, 'api.example.com')).to eq('api.example.com')
      end
    end
  end
end
