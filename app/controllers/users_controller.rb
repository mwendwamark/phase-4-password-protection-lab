class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def create
    user = User.create!(user_params)
    session[:user_id] = user.id if user.valid?
    render json: user, status: :created
  end



  def show
    user = User.find_by(id: session[:user_id])
    if user
      session[:user_id] = user.id
      render json: user
    else
      render json: { error: "Not Authorized" }, status: :unauthorized
    end
  end

  private

  def render_unprocessable_entity_response(invalid)
    render json: { erros: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_unauthorized_response
    render json: { error: "Not Authorized" }, status: :unauthorized
  end

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end
end
