class PhonesController < ApplicationController
  def index
    @phones = Phone.all

    render json: @phones, status: :ok
  end

  def show
    @phone = Phone.find(params[:id])

    render json: @phone, status: :ok
  end

  def create
    @phone = Phone.new(phone_params)

    if @phone.save
      render json: @phone, status: :created
    else
      render json: @phone.errors, status: :unprocessable_entity
    end
  end

  def update
    @phone = Phone.find(params[:id])
    if @phone.update(phone_params)
      render json: @phone, status: :ok
    else
      render json: @phone.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @phone = Phone.find(params[:id])

    @phone.destroy
  end

  private

  def phone_params
    params.require(:phone).permit(:number, :contact_id)
  end
end
