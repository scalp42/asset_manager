class User
  include MongoMapper::Document
  include Gravtastic
  is_gravtastic!

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:token_authenticatable, :timeoutable

  key :email, String
  key :encrypted_password, String
  key :current_sign_in_at, Date
  key :last_sign_in_at, Date
  key :current_sign_in_ip, String
  key :last_sign_in_ip, String
  key :sign_in_count, Integer
  key :remember_created_at, Date
  key :reset_password_token, String
  key :reset_password_sent_at, Date
  key :authentication_token, String

  key :first_name, String
  key :last_name, String
  key :active, Boolean
  key :full_name, String
  key :is_admin , Boolean

  def inactive_message
    "Sorry, this account has been deactivated."
  end

  def active?
    !!active
  end
end
