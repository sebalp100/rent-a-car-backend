class BrandsController < ApplicationController
  before_action :set_brand, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[index show]
  load_and_authorize_resource

  # GET /brands
  def index
    @brands = Brand.all

    render json: @brands.map { |brand| brand_with_photo_url(brand) }
  end

  # GET /brands/1
  def show
    render json: brand_with_photo_url(@brand)
  end

  # POST /brands
  def create
    @brand = Brand.new(brand_params)
    authorize! :create, @brand

    if @brand.save
      render json: brand_with_photo_url(@brand), status: :created, location: brand_url(@brand)
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /brands/1
  def update
    if @brand.update(brand_params)
      render json: brand_with_photo_url(@brand)
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  # DELETE /brands/1
  def destroy
    @brand.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brand
    @brand = Brand.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def brand_params
    params.require(:brand).permit(:name, :photo)
  end

  def brand_with_photo_url(brand)
    brand_data = brand.as_json
    brand_data[:photo_url] = photo_url(brand)
    brand_data
  end

  def photo_url(brand)
    Rails.application.routes.url_helpers.rails_blob_path(brand.photo, only_path: true) if brand.photo.attached?
  end
end
