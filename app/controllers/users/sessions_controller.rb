class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix

  respond_to :json

  private  

  def respond_with(current_user, _opts = {})
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end  
  
  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ').last
        jwt_payload = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!).first
        current_user = User.find_by(id: jwt_payload['sub'])
      rescue JWT::DecodeError => e
        current_user = nil
        Rails.logger.error "JWT Decode Error: #{e.message}"
      end
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end