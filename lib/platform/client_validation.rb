# frozen_string_literal: true

module Platform
  # Platform::ClientValidation
  module ClientValidation
    extend ActiveSupport::Concern

    included do
      before_action :validate_client_name
    end

    INVALID_CLIENT = { error: 'invalid_client', detail: 'header' }.freeze

    private

    def validate_client_name
      client_name = request.headers['X-Client-Name']

      return render json: INVALID_CLIENT, status: :unauthorized unless Settings.client_names.include?(client_name)

      NewRelic::Agent.add_custom_attributes(client_name:)
    end
  end
end
