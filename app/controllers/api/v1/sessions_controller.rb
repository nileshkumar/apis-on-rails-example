class Api::V1::SessionsController < ApplicationController
  def create
    email = params[:session][:email]
    user = email.present? && User.find_by(email: email)

    if user && user.valid_password?(params[:session][:password])
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { message: 'Invalid email or password' }, status: 422
    end
  end
end
