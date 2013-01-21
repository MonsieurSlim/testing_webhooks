class User < ActiveRecord::Base
  has_many :projects, :dependent => :destroy #projects we own
  has_and_belongs_to_many :participations, :association_foreign_key => 'project_id', :class_name => 'Project'

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,:token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid
  def to_s
    if confirmed?
      email
    else
      "#{email} (invited)"
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_or_create_for_github_oauth(auth, signed_in_resource=nil)
    unless user = User.where(:provider => auth.provider, :uid => auth.uid).first
      if user = User.find_by_email(auth.info.email)
        #user.name ||= auth.extra.raw_info.name
        user.provider ||= auth.provider
        user.uid ||= auth.uid
        user.save
      else
        user = User.create(#name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
      end
    end
    user
  end
end
