module Countir
  class Client
    include ResourceBasedMethods

    URL = 'https://api.countir.jp'

    def initialize(api_key: nil)
      @api_key = api_key
    end

    private

    def connection
      @cconection ||=
        Faraday.new(url: URL) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end
    end

    def get(url, params = {}, resource_class:)
      response = connection.get do |req|
        req.url url
        req.headers["Authorization: Bearer"] = @api_key
        req.params = params
      end

      result(response, resource_class)
    end

    def post(url, params, resource_class: nil)
      response = connection.post do |req|
        req.url url
        req.headers["Authorization: Bearer"] = @api_key
        req.params = params
      end

      result(response, resource_class)
    end

    def result(response, resource_class = nil)
      status  = response.status
      header  = response.headers
      body    = response.body
      message = nil

      case response.status
      when 200...300
        nil
      when 301, 302, 303, 307
        message ||= sprintf('Redirect to %s', header[:location])
        raise Countir::RedirectError.new(message, status_code: status, header: header, body: body)
      when 401
        message ||= 'Unauthorized'
        raise Countir::AuthorizationError.new(message, status_code: status, header: header, body: body)
      when 304, 400, 402...500
        message ||= 'Invalid request'
        raise Countir::ClientError.new(message, status_code: status, header: header, body: body)
      when 500...600
        message ||= 'Server error'
        raise Countir::ServerError.new(message, status_code: status, header: header, body: body)
      else
        logger.warn(sprintf('Encountered unexpected status code %s', status))
        message ||= 'Unknown error'
        raise Countir::TransmissionError.new(message, status_code: status, header: header, body: body)
      end

      Countir::Result.new(response, resource_class)
    end

  end
end
