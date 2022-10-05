class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show update destroy]
  def index
    @contacts = Contact.includes(:kind, :phones, :address).all

    render json: @contacts, status: :ok, include: %i[phones address kind]
  end

  def show
    render json: @contact, status: :ok, include: %i[phones address kind]
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created, include: %i[phones address phones]
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def update
    if @contact.update(contact_params)
      render json: @contact, status: :ok, include: %i[phones address phones]
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :birthdate, :kind_id,
                                    phones_attributes: %i[id number _destroy],
                                    address_attributes: %i[id street city])
  end
end
