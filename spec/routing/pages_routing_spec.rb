require "spec_helper"

describe "routes for Pages" do
  it "routes /pages/about to pages#about" do
        get("/pages/about").should
             route_to("pages#about")
      end
  it "routes /pages/home to the pages#home" do 
        get("/pages/home").should route_to("pages#home")
  end  
  
  it "routes /pages/contact to the pages#contact" do 
        get("/pages/contact").should route_to("pages#contact")
  end
  
  it "routes /pages/help to the pages#help" do 
        get("/pages/help").should route_to("pages#help")
  end 
      
end  