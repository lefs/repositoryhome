class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :permissions,
           dependent: :delete_all,
           inverse_of: :user
  has_many :repositories, through: :permissions
  has_many :keys, dependent: :delete_all

  accepts_nested_attributes_for :permissions

  # Setup accessible (or protected) attributes for your model.
  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :admin,
                  :permissions_attributes

  validates :email, uniqueness: true,
                    length: { within: 5..254 }, # According to http://stackoverflow.com/questions/386294/maximum-length-of-a-valid-email-id/574698#574698
                    format: { with: /^.+@.+$/i }

  # Generate password if no password is set.
  before_validation :generate_password, on: :create, if: "password.blank?"
  before_validation :mark_permissions_for_destruction

  def self.non_admins
    where(admin: false).all
  end

  protected

  def generate_password
    return unless self.password.blank?

    # Generate a 16 character long random alphanumeric password.
    chars = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    password = (0..16).map { chars[rand(chars.length)] }.join
    self.password = self.password_confirmation = password
  end

  def mark_permissions_for_destruction
    permissions.each do |permission|
      permission.mark_for_destruction if permission.name.blank?
    end
  end
end
