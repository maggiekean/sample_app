class PagesController < ApplicationController

  def home
    @page_title = "Home"
  end

  def contact
    @page_title = "Contact"
  end

  def about
    @page_title = "About"
  end
  
  def help
    @page_title = "Help"
  end
end