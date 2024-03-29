# frozen_string_literal: true
module Notion
  module Faraday
    module Response
      class WrapError < ::Faraday::Response::Json
        UNAVAILABLE_ERROR_STATUSES = (500..599).freeze

        def on_complete(env)
          return unless UNAVAILABLE_ERROR_STATUSES.cover?(env.status)

          raise Notion::Api::Errors::UnavailableError.new('unavailable_error', env.response)
        end

        def call(env)
          super
        rescue ::Faraday::TimeoutError, ::Faraday::ConnectionFailed
          raise Notion::Api::Errors::TimeoutError.new('timeout_error', env.response)
        end
      end
    end
  end
end
