class ApplicationController < ActionController::API
    include ActionController::Cookies
    skip_before_action :verify_authenticity_token, raise: false
    
    def hello_world
        session[:count] = (session[:count] || 0) + 1
        render json: { count: session[:count] }
    end
end
