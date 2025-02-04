class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { message: I18n.t("errors.messages.email_taken") }
  validates :password, length: { minimum: 6 }

  # Hooks
  before_save :downcase_email
  before_destroy :prevent_last_admin_deletion
  before_update :prevent_last_admin_removal

  def admin?
    self.admin
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def prevent_last_admin_deletion
    if admin? && User.where(admin: true).count == 1
      self.errors.add(:base, :last_admin_deletion)
      throw(:abort)
    end
  end

  def prevent_last_admin_removal
    if admin_changed?(from: true, to: false) && User.where(admin: true).count == 1
      self.errors.add(:base, :last_admin_removal)
      throw(:abort)
    end
  end
end
