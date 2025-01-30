class Task < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :content, presence: true

  # Config for pagination (using gem 'kaminari')
  paginates_per 10
end
