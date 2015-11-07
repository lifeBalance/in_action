class Admin::ApplicationController < ApplicationController
  before_action :authorize_admin!

  skip_after_action :verify_authorized, :verify_policy_scoped

  def index
  end

  private
    def authorize_admin!
      authenticate_user! # Provided by Devise

      unless current_user.admin?
        redirect_to root_path, alert: 'You must be an admin to do that.'
      end
    end
end
