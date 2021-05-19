class SignupController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      payload = {user_id: user.id}
      # Sometimes it is not secure enough to store the refresh tokens in web / JS clients.
      # This is why you have the option to only use an access token and to not pass the refresh token to the client at all.
      # Session accepts refresh_by_access_allowed: true setting, which links the access token to the corresponding refresh token.
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      # passes an access token token via cookies and renders CSRF:
      tokens = session.login
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access]
                          httponly: true
                          secure: Rails.env.production?)

      render json: { csrf: tokens[:csrf] }
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end


  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end
