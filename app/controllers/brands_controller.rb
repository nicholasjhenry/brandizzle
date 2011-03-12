class BrandsController < ApplicationController
  def index
    @brands = Brand.all
  end

  def new
    @brand = Brand.new
  end

  def edit
    @search = Search.new
    @brand = Brand.find(params[:id])
  end

  def create
    @brand = Brand.new(params[:brand])
    if @brand.save
      flash[:notice] = "Brand successfully created"
      redirect_to edit_brand_url(@brand)
    else
      render :new
    end
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update_attributes(params[:brand])
      flash[:notice] = "Brand updated"
      redirect_to edit_brand_url(@brand)
    else
      render :edit
    end
  end

  def destroy
    @brand = Brand.find(params[:id]) 
    @brand.destroy
    flash[:notice] = "Brand deleted"
    redirect_to brands_path
  end
end
