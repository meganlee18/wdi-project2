class Photo < ActiveRecord::Base
  validates :name, length: {in: 6..100} #Set rule that user must save a name
  validates :image_url, presence: true

  has_many :comments
end
