class User < ApplicationRecord

  has_secure_password

  def self.authenticate_with_credentials(email, password)
    user = User.find_by(email: email.downcase.strip)

    if user && user.authenticate(password)
      user
    else
      nil
    end 
  end

  before_validation :downcase_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 10 }

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

end
