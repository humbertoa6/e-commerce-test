class ApplicationController < ActionController::Base
  # current user shuld be defined at .env file
  def current_user
    User.find_by(email: ENV['DEMO_USER_EMAIL'])
  end
  helper_method :current_user
end
