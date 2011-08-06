class SearchesController < ApplicationController
  def create
    @brand  = Brand.find(params[:brand_id])
    if @search = @brand.add_search(params[:search][:term])
      flash[:notice] = "Search term added"
    else
      flash[:error] = "Search term failed. Please provide a term"
    end

    redirect_to edit_brand_url(@brand)
  end

  def destroy
    brand  = Brand.find(params[:brand_id])
    search = brand.searches.find(params[:id])
    search.destroy
    redirect_to edit_brand_url(brand), :notice => "Search term deleted" 
  end
end
