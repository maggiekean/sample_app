class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :microposts, dependent: :destroy
  has_secure_password
  before_save :create_remember_token

  validates_presence_of :name, :message => "Name is a required field"
  validates_length_of :name, :maximum => 50, :message => "Maximum length for Name is 50 characters"
  validates_presence_of :email, :message => "Email is a required field"
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :message => "Invalid email format"
  validates_uniqueness_of :email, :case_sensitive => false, :message => "Someone with that email address is already registered"
  validates_length_of :password, :minimum => 6, :message => "Password must be at least 6 characters long"
  
  def feed
      # This is preliminary. See "Following users" for the full implementation.
      Micropost.where("user_id = ?", id)
  end
   
  private

      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end

end