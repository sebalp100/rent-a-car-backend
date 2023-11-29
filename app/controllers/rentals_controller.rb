class RentalsController < ApplicationController
  before_action :set_rental, only: %i[show update destroy]
  load_and_authorize_resource

  # GET /rentals
  def index
    @rentals = current_user.rentals.includes(:car)

    render json: @rentals.as_json(include: { car: { only: [:model, :year, :price] } })
  end

  # GET /rentals/1
  def show
    @rental = Rental.find_by(id: params[:id])

    if @rental
      render json: @rental
    else
      render json: { error: "Record not found" }, status: :not_found
    end
  end

  # POST /rentals
  def create
    @rental = current_user.rentals.build(rental_params)

    if @rental.save
      render json: @rental, status: :created, location: @rental
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rentals/1
  def update
    if @rental.update(rental_params)
      render json: @rental
    else
      render json: @rental.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rentals/1
  def destroy
    @rental.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = current_user.rentals.find_by(id: params[:id])

    if @rental.nil?
      render json: { error: "Record not found" }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def rental_params
    params.require(:car).permit(:car_id, :user_id, :rental_date, :return_date)
  end
end
