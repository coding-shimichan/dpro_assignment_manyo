class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :login_required

  private

  def login_required
    if (logged_in? === false)
      flash[:alert] = t("errors.messages.login_required")
      redirect_to new_session_path
    end
  end

  def logout_required
    if (logged_in?)
      flash[:alert] = t("errors.messages.logout_required")
      redirect_to tasks_path
    end
  end

  def admin_privileges_required
    if (current_user.admin? == false)
      flash[:alert] = t("errors.messages.admin_privileges_required")
      redirect_to tasks_path
    end
  end
end
