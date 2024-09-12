module ApiException
  EXCEPTIONS = {
    #400
    "ActiveRecord::RecordInvalid" => { status: 400, error_code: 40001, message: "Invalid request" },
    "BadRequest" => { status: 400, error_code: 40002, message: "Invalid request" },

    #401
    "Unauthorized" => { status: 401, error_code: 40101, message: "Resource unauthorized" },

    #403
    "Forbidden" => { status: 403, error_code: 40301, message: "Resource forbidden" },

    #404
    "ActiveRecord::RecordNotFound" => { status: 404, error_code: 404, message: "Cannot find record" },
    "NotFound" => {status: 404, error_code: 404, message: "Record not found"}
  }

  class BaseError < StandardError
    def initialize(msg = nil)
      @message = msg
    end

    def message
      @message || nil
    end
  end

  module Handler
    def self.included(klass)
      klass.class_eval do
        EXCEPTIONS.each do |exception_name, context|
          unless ApiException.const_defined?(exception_name)
            ApiException.const_set(exception_name, Class.new(BaseError))
            exception_name = "ApiException::#{exception_name}"
          end

          rescue_from exception_name do |exception|
            render status: context[:status], json: { error_code: context[:error_code], message: context[:message], detail: (exception.message) }.compact
          end
        end
      end
    end
  end
end