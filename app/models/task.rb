class Task < ApplicationRecord
  # Attributes
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true

  # Config for pagination (using gem 'kaminari')
  paginates_per 10
end
