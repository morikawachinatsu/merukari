class Item < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :favorites, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "price", "title", "updated_at", "user_id"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["comments", "favorites", "images_attachments", "images_blobs", "item_tag_relations", "tags", "user"]
  end

  def favorited_by?(user)
    return false if user.nil?  
    favorites.exists?(user_id: user.id)
  end

  has_many :comments, dependent: :destroy
   has_many :item_tag_relations, dependent: :destroy
  has_many :tags, through: :item_tag_relations, dependent: :destroy
end
