module Countir
  class Result
    extend Forwardable

    attr_reader :response

    def initialize(response, resource_class = nil)
      @response       = response
      @resource_class = resource_class
    end

    def_delegators :@response, :status, :headers, :body

    def data?
      !(self.body.nil? || self.body.empty?)
    end

    def data
      @data ||= begin
        if data?
          data = JSON.parse(self.body)

          if @resource_class
            @resource_class.response_schema(data)
          else
            data
          end
        end
      end
    end

    def next_offset
      if data?
        JSON.parse(self.body)["next_offset"] rescue nil
      end
    end

  end
end
