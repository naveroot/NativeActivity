class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.find [1,2]
  end

  def show
    @activities = Activity.all
  end

  def city_views
  end

  def new
    @city = City.new
  end

  def edit
  end

  # POST /cities
  def create
    @city = City.new(city_params)

    if @city.save
      redirect_to @city
    else
      render :new
    end
  end

  # PATCH/PUT /cities/1
  def update
    if @city.update(city_params)
      redirect_to @city
    else
      render :edit
    end
  end

  def destroy
    @city.destroy
    redirect_to cities_url
  end

  private

  def set_city
    @city = City.find(params[:id])
  end


  def city_params
    params.require(:city).permit(:name, :photo)
  end
end