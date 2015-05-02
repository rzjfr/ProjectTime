class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :project_not_authorized

  private

    def project_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      flash[:danger] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default 
      #"You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
end
