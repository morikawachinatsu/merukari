class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  

  has_many :items
  has_many :favorites, dependent: :destroy
  has_many :favorited_items, through: :favorites, source: :item

  has_many :comments, dependent: :destroy

  has_many :items, dependent: :destroy
  has_one_attached :image 

  has_many :likes, dependent: :destroy
  has_many :liked_items, through: :likes, source: :item
  

  validates :profile, length: { maximum: 200 }
  def already_liked?(item)
    self.likes.exists?(item_id: item.id)
  end
  def already_favorited?(item)
    self.favorites.exists?(item_id: item.id)
  end

end
