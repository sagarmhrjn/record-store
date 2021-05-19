class ApplicationController < ActionController::API
    # setup our application controller to hook into JWT sessions
    # taken from jwt_sessions github
    include JWTSessions::RailsAuthorization
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    private

    def current_user
        @current_user ||= User.find(payload['user_id'])     #payload comes from jwt sessions
    end
    def not_authorized
        render json: { error: "Not authorized" }, status: :unauthorized
    end 
end
