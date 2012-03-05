class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                     class_name:  "Relationship",
                                     dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_secure_password
  before_save :create_remember_token

  validates_presence_of :name, :message => "Name is a required field"
  validates_length_of :name, :maximum => 50, :message => "Maximum length for Name is 50 characters"
  validates_presence_of :email, :message => "Email is a required field"
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, :message => "Invalid email format"
  validates_uniqueness_of :email, :case_sensitive => false, :message => "Someone with that email address is already registered"
  validates_length_of :password, :minimum => 6, :message => "Password must be at least 6 characters long"

  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
      relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def feed
      Micropost.from_users_followed_by(self)
  end
    
  private

      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end

end