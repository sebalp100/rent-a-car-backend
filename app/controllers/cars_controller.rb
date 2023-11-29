class CarsController < ApplicationController
  before_action :set_car, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[index show]
  load_and_authorize_resource

  # GET /cars
  def index
    if params[:featured] == 'true'
      @cars = Car.where(featured: true)
    elsif params[:brand_id].present?
      @cars = Car.includes(:brand).where(brand_id: params[:brand_id])
    elsif params[:model].present? || params[:year].present?
      @cars = Car.includes(:brand).where('model ILIKE ? OR year ILIKE ?', "%#{params[:model]}%", "%#{params[:year]}%")
    else
      @cars = Car.includes(:brand).all
    end

    render json: @cars.map { |car| car_with_photo_url(car) }
  end

  # GET /cars/1
  def show
    render json: car_with_photo_url(@car)
  end

  # POST /cars
  def create
    @car = Car.new(car_params)

    if @car.save
      render json: car_with_photo_url(@car), status: :created, location: car_url(@car)
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cars/1
  def update
    @car.update!(car_params)
    render json: car_with_photo_url(@car)
  end

  def destroy
    @car.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    @car = Car.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def car_params
    params.require(:car).permit(:model, :year, :top_speed, :description, :cc, :engine, :mileage, :price, :reserved,
                                :featured, :brand_id, :photo)
  end

  def car_with_photo_url(car)
    car_data = car.as_json
    car_data[:photo_url] = photo_url(car)
    car_data
  end

  def photo_url(car)
    Rails.application.routes.url_helpers.rails_blob_path(car.photo, only_path: true) if car.photo.attached?
  end
end
