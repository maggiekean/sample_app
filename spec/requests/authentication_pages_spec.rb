require 'spec_helper'

describe "Authentication" do #Authentication

  subject { page }
  describe "signin page" do #Authentication/Signin page
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end#Signin page
  describe "signin" do#Authentication/signin
      before { visit signin_path }
      describe "with invalid information" do#Authentication/signin/invalid
            before { click_button "Sign in" }

            it { should have_selector('title', text: 'Sign in') }
            it { should have_selector('div.flash.error', text: 'Invalid') }
            describe "after visiting another page" do#Authentication/signin/invalid/visiting
                    before { click_link "Home" }
                    it { should_not have_selector('div.flash.error') }
                  end #after visiting
          end #invalid info
      describe "with valid information" do#Authentication/signin/valid
          let(:user) { FactoryGirl.create(:user) }
          before { test_sign_in(user) } 

          it { should have_selector('title', text: user.name) }
          it { should have_link('Users',    href: users_path) }
          it { should have_link('Profile', href: user_path(user)) }
          it { should have_link('Settings', href: edit_user_path(user)) }
          it { should have_link('Sign out', href: signout_path) }
          it { should_not have_link('Sign in', href: signin_path) }
             describe "followed by signout" do#Authentication/signin/valid/signout
              before { click_link "Sign out" }
              it { should have_link('Sign in') }
            end #signout
        end#valid info     
      end#signin
      describe "authorization" do    #Authentication/authorization         
        
        describe "for non-signed-in users" do#Authentication/authorization/non-signin         
          let(:user) { Factory(:user) }

          describe "in the Users controller" do #Authentication/authorization/non-signin/UC    

            describe "visiting the edit page" do#Authentication/authorization/non-signin/UC/edit
              before { visit edit_user_path(user) }
              it { should have_selector('title', text: 'Sign in') }
            end #visiting edit
            
            describe "visiting user index" do#Authentication/authorization/non-signin/UC/index
              before { visit users_path }
                it { should have_selector('title', text: 'Sign in') }
              end#visiting user index
                  
            describe "submitting to the update action" do#Authentication/authorization/non-signin/UC/update
              before { put user_path(user) }
              specify { response.should redirect_to(signin_path) }
            end #update
          end#in users controller
          describe "in the Relationships controller" do#Authentication/authorization/non-signin/relationships
              describe "submitting to the create action" do#Authentication/authorization/non-signin/relationships/create
                before { post relationships_path }
                specify { response.should redirect_to(signin_path) }
              end #submitting create

              describe "submitting to the destroy action" do#Authentication/authorization/non-signin/relationships/destroy
                before { delete relationship_path(1) }
                specify { response.should redirect_to(signin_path) }          
              end#submitting destroy
            end#relationships controller
            describe "when attempting to visit a protected page" do#Authentication/authorization/non-signin/protected
              before do
                visit edit_user_path(user)
                fill_in "Email",    with: user.email
                fill_in "Password", with: user.password
                click_button "Sign in"
              end#before
              describe "after signing in" do#Authentication/authorization

                it "should render the desired protected page" do
                  page.should have_selector('title', text: 'Edit user')
                end #should render desired
              end# after signing in
              describe "when signing in again" do
                  before do
                    visit signin_path
                    fill_in "Email",    with: user.email
                    fill_in "Password", with: user.password
                    click_button "Sign in"
                  end
                  it "should render the default (profile) page" do
                    page.should have_selector('title', text: user.name) 
                  end #render profile
                end#signing in again
            end#protected
          end#non-signin           
      describe "as wrong user" do
            let(:user) { FactoryGirl.create(:user) }
            let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
            before { test_sign_in user }

            describe "visiting Users#edit page" do
              before { visit edit_user_path(wrong_user) }
              it { should have_selector('title', text: 'Home') }
            end

            describe "submitting a PUT request to the Users#update action" do
              before { put user_path(wrong_user) }
              specify { response.should redirect_to(root_path) }
            end#submitting
          end#wrong user
          describe "as non-admin user" do
                let(:user) { FactoryGirl.create(:user) }
                let(:non_admin) { FactoryGirl.create(:user) }

                before { test_sign_in non_admin } 

                describe "submitting a DELETE request to the Users#destroy action" do
                  before { delete user_path(user) }
                  specify { response.should redirect_to(root_path) }        
                end
              end 
           
         describe "in the Microposts controller" do

              describe "submitting to the create action" do
                before { post microposts_path }
                specify { response.should redirect_to(signin_path) }
              end

              describe "submitting to the destroy action" do
                before do
                  micropost = FactoryGirl.create(:micropost)
                  delete micropost_path(micropost)
                end
                specify { response.should redirect_to(signin_path) }
              end
            end
        end#authorization
      end#authentication