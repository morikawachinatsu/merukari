class FavoritesController < ApplicationController
  before_action :set_item

  def create
    @item.favorites.create(user: current_user)
    redirect_back fallback_location: root_path
  end

  def destroy
    favorite = @item.favorites.find_by(user: current_user)
    favorite.destroy if favorite
    redirect_back fallback_location: root_path
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
