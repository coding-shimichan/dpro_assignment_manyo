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

  # Queries
  scope :in_status, -> (status) { where(status: status) if status.present? }
  scope :fuzzy_search, -> (title) { where("title ILIKE ?", "%#{title}%") if title.present? }
  scope :sorted_by_deadline, -> { order(deadline_on: :asc) }
  scope :sorted_by_priority, -> { order(priority: :desc) }
  scope :sorted_by_creation, -> { order(created_at: :desc) }

  # Config for pagination (using gem 'kaminari')
  paginates_per 10
end
