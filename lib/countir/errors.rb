module Countir

  class Error < StandardError
    attr_reader :status_code
    attr_reader :header
    attr_reader :body

    def initialize(err, status_code: nil, header: nil, body: nil)
      @cause = err.respond_to?(:backtrace) ? err : nil
      @status_code = status_code
      @header = header.dup unless header.nil?
      @body = JSON.parse(body) rescue body

      message =
        if @body["error"]["message"]
          @body["error"]["message"]
        elsif err.respond_to?(:backtrace)
          err.message
        else
          err.to_s
        end

      super(message)
    end

    def backtrace
      if @cause
        @cause.backtrace
      else
        super
      end
    end
  end

  # An error which is raised when there is an unexpected response or other
  # transport error that prevents an operation from succeeding.
  class TransmissionError < Error
  end

  # An exception that is raised if a redirect is required
  #
  class RedirectError < Error
  end

  # A 4xx class HTTP error occurred.
  class ClientError < Error
  end

  # A 4xx class HTTP error occurred.
  class RateLimitError < Error
  end

  # A 401 HTTP error occurred.
  class AuthorizationError < Error
  end

  # A 5xx class HTTP error occurred.
  class ServerError < Error
  end

  # Error class for problems in batch requests.
  class BatchError < Error
  end

  # Paramator is invalid.
  class InvalidParameter < Error
  end

end
