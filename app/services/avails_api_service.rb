require 'net/http'
require 'uri'
require 'json'

class AvailsApiService
  class AuthenticationError < StandardError; end
  class RequestError < StandardError; end

  attr_reader :token, :path

  def initialize(path:, domain: nil, method: :get, protocol: 'https')
    @domain = establish_domain(domain).to_s.downcase
    @path = path
    @http_method = method.to_s.downcase
    validate_http_method
    @protocol = protocol.to_s.downcase
    validate_protocol
    @token = fetch_token
  end

  def request(params: nil)
    raise AuthenticationError, 'No valid token available' unless token

    uri = URI.parse("#{@protocol}://#{@domain}/#{path}")
    uri.query = encode_params(params) if params

    request = build_request(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Content-Type'] = 'application/json'

    response = make_request(uri, request)
    handle_response(response)
  rescue StandardError => e
    { success: false, error: e.message }
  end

  private

  def validate_http_method
    valid_methods = %w[get post put patch delete]
    return if valid_methods.include?(@http_method)

    raise RequestError, "Unsupported HTTP method: #{@http_method}. Must be one of: #{valid_methods.join(', ')}"
  end

  def validate_protocol
    return if %w[http https].include?(@protocol)

    raise RequestError, "Unsupported protocol: #{@protocol}. Must be 'http' or 'https'"
  end

  def establish_domain(supplied_domain)
    return 'localhost:8000' if Rails.env.development? && supplied_domain.nil?
    return supplied_domain if supplied_domain.present?

    Rails.application.credentials[Rails.env.to_sym].avails_api_domain
  end

  def fetch_token
    auth_uri = URI.parse("#{@protocol}://#{@domain}/api/v1/authentication_tokens")

    auth_request = Net::HTTP::Post.new(auth_uri)
    auth_request['Content-Type'] = 'application/json'
    auth_request.body = {
      api_key: Rails.application.credentials[Rails.env.to_sym].avails_api_key,
      secret_key: Rails.application.credentials[Rails.env.to_sym].avails_secret_key
    }.to_json

    auth_response = make_request(auth_uri, auth_request)

    raise AuthenticationError, "Authentication failed: #{auth_response.message}" unless auth_response.is_a?(Net::HTTPSuccess)

    JSON.parse(auth_response.body)['token']
  end

  def build_request(uri)
    request_class = case @http_method
                    when 'get'    then Net::HTTP::Get
                    when 'post'   then Net::HTTP::Post
                    when 'put'    then Net::HTTP::Put
                    when 'patch'  then Net::HTTP::Patch
                    when 'delete' then Net::HTTP::Delete
                    else raise RequestError, "Unsupported HTTP method: #{@http_method}"
                    end

    request_class.new(uri)
  end

  def make_request(uri, request)
    Net::HTTP.start(
      uri.hostname,
      uri.port,
      use_ssl: use_ssl?(uri)
    ) do |http|
      http.request(request)
    end
  end

  def use_ssl?(uri)
    return false if ['localhost', '127.0.0.1'].include?(uri.hostname)

    uri.scheme == 'https'
  end

  def handle_response(response)
    case response
    when Net::HTTPSuccess
      { success: true, data: JSON.parse(response.body) }
    else
      { success: false, error: response.message, status: response.code }
    end
  end

  def encode_params(params)
    return nil if params.nil?

    params.to_query
  end
end
