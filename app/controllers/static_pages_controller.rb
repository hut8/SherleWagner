class StaticPagesController < ApplicationController
  def index
  end

  def edit_homepage
    @copy = File.read('public/home_page_copy.html')
  end

  def update_homepage
    copy = params[:home_page_copy]
    render 'root'
  end
  
  def upload_page
  end

  def catalog
  end

  def contact
  end

  def showrooms
  end

  def history
  end


end
