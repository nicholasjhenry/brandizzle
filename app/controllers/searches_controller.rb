class SearchesController < ApplicationController
  def create
    @brand  = Brand.find(params[:brand_id])
    @search = @brand.searches.build(params[:search])

    if @search.save
      flash[:notice] = "Search term added"
    else
      flash[:error] = "Search term failed. Please provide a term"
    end

    redirect_to edit_brand_url(@brand)
  end
end
