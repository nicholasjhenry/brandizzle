class PagesController < ApplicationController
  def show
    page_id = params[:id]
    if %w(about).include?(page_id)
      render "pages/show/#{page_id}"
    else
      render :file => 'public/404.html', :status => 404
    end
  end
end
