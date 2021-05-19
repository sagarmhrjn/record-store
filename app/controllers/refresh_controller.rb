class RefreshController < ApplicationController
    before_action :authorize_refresh_by_access_request!
  
    def create
      session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)
      tokens  = session.refresh_by_access_payload
      # here goes malicious activity alert
      # Optionally refresh_by_access_payload accepts a block argument (the same way refresh method does). 
      # The block will be called if the refresh action is performed before the access token is expired. 
      # Thereby it's possible to prohibit users from making refresh calls while their access token is still active.
      raise JWTSessions::Errors::Unauthorized, "Something's not right here!"
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
  
      render json: { csrf: tokens[:csrf] }
    end
end