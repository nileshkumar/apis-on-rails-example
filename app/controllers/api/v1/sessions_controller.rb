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

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end
end
