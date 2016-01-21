class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) } #created_at: :desc is like 'created_at
  # DESC'
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
