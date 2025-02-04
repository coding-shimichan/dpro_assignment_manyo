class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { message: I18n.t("errors.messages.email_taken") }
  validates :password, length: { minimum: 6 }

  # Hooks
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
