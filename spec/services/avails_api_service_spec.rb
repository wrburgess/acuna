require 'rails_helper'

RSpec.describe AvailsApiService do
  let(:valid_path) { 'api/v1/titles' }
  let(:auth_token) { 'eyJhbGciOiJIUzI1NiJ9.mock_token' }
  let(:application_name) { 'Test Application' }
  let(:expiration_date) { 24.hours.from_now }

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

  let(:auth_response) do
    {
      token: auth_token,
      exp: expiration_date.iso8601,
      application_name: application_name
    }.to_json
  end

  let(:titles_response) do
    {
      data: [
        {
          id: 1,
          name: 'Movie Title 1',
          created_at: Time.current.iso8601,
          updated_at: Time.current.iso8601
        },
        {
          id: 2,
          name: 'Movie Title 2',
          created_at: Time.current.iso8601,
          updated_at: Time.current.iso8601
        }
      ]
    }.to_json
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

    context 'with successful authentication and API call' do
      before do
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
            body: auth_response,
            headers: { 'Content-Type' => 'application/json' }
          )

        stub_request(:get, "https://api.example.com/#{valid_path}")
          .with(
            headers: {
              'Authorization' => "Bearer #{auth_token}",
              'Content-Type' => 'application/json'
            }
          )
          .to_return(
            status: 200,
            body: titles_response,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns parsed titles data' do
        response = service.request
        expect(response[:success]).to be true
        expect(response[:data]['data'].length).to eq(2)
        expect(response[:data]['data'].first['name']).to eq('Movie Title 1')
      end
    end

    context 'with invalid credentials' do
      before do
        stub_request(:post, 'https://api.example.com/api/v1/authentication_tokens')
          .to_return(
            status: 401,
            body: { error: 'unauthorized' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'raises AuthenticationError' do
        expect { service.request }.to raise_error(AvailsApiService::AuthenticationError)
      end
    end

    context 'with expired token' do
      before do
        stub_request(:post, 'https://api.example.com/api/v1/authentication_tokens')
          .to_return(status: 200, body: auth_response)

        stub_request(:get, "https://api.example.com/#{valid_path}")
          .to_return(
            status: 401,
            body: { error: 'Token has expired' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'returns error response' do
        response = service.request
        expect(response[:success]).to be false
        expect(response[:status]).to eq('401')
      end
    end

    context 'with ransack parameters' do
      let(:search_params) { { q: { name_cont: 'Movie' } } }
      let(:service) { AvailsApiService.new(path: valid_path, method: :get) }
      let(:encoded_query) { 'q%5Bname_cont%5D=Movie' }

      before do
        stub_request(:post, 'https://api.example.com/api/v1/authentication_tokens')
          .to_return(status: 200, body: auth_response)

        stub_request(:get, "https://api.example.com/#{valid_path}")
          .with(
            headers: {
              'Authorization' => "Bearer #{auth_token}",
              'Content-Type' => 'application/json'
            },
            query: { 'q[name_cont]' => 'Movie' }
          )
          .to_return(
            status: 200,
            body: titles_response,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'properly handles search parameters' do
        response = service.request(params: search_params)
        expect(response[:success]).to be true
        expect(response[:data]['data']).to be_an(Array)
      end
    end
  end

  describe 'domain handling' do
    context 'in development' do
      before do
        allow(Rails.env).to receive(:development?).and_return(true)

        stub_request(:post, 'http://localhost:8000/api/v1/authentication_tokens')
          .with(
            body: {
              api_key: 'test_api_key',
              secret_key: 'test_secret_key'
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(
            status: 200,
            body: auth_response,
            headers: { 'Content-Type' => 'application/json' }
          )
      end

      it 'uses localhost when no domain provided' do
        service = AvailsApiService.new(path: valid_path, protocol: 'http')
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
