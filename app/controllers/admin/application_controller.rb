module Admin
  class ApplicationController < ApplicationController
    include ApiException::Handler

    before_action :authenticate_user!
    before_action :require_admin!

    protected

    def require_admin!
      raise ApiException::Forbidden.new('Require admin') unless current_user&.admin?
    end
  end
end