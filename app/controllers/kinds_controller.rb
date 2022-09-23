class KindsController < ApplicationController
  before_action :set_kind, only: %i[show update destroy]
  def index
    @kinds = Kind.all

    render json: @kinds, status: :ok
  end

  def show
    render json: @kind, status: :ok
  end

  def create
    @kind = Kind.new(kind_params)

    if @kind.save
      render json: @kind, status: :created
    else
      render json: @kind.errors, status: :unprocessable_entity
    end
  end

  def update
    if @kind.update(kind_params)
      render json: @kind, status: :ok
    else
      render json: @kind.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @kind.destroy
  end

  private

  def set_kind
    @kind = Kind.find(params[:id])
  end

  def kind_params
    params.require(:kind).permit(:description)
  end
end
