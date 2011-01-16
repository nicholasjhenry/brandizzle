class PagesController < ApplicationController
  def show
    if %w(about).include?(params[:id])
      render "pages/show/#{params[:id]}"
    else
      render :file => 'public/404.html', :status => 404
    end
  end
end
