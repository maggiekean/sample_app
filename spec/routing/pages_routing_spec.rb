require "spec_helper"

describe "routes for Pages" do
  it "routes /pages/about to pages#about" do
        get("/pages/about").should
             route_to("pages#about")
      end
  it "routes /pages/home to the /home action" do 
        get("/pages/home").should route_to("pages#home")
  end   
      
end  