class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) 
    @favorited_items = @user.favorited_items
  end
end
