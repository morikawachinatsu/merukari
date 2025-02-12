class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @q = Item.ransack(params[:q])
    @items = @q.result(distinct: true).includes(:user).page(params[:page]).order("created_at desc")
    @item = Item.new
      if params[:tag]
        Tag.create(name: params[:tag])
      end

      if params[:tag_ids]
        @items = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_items = Tag.find_by(name: key).items
            @items = @items.empty? ? tag_items : @items & tag_items
          end
        end
      end
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.new(item_params)
    item.user_id = current_user.id
    if item.save
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def show
    @item = Item.find(params[:id])
    @comments = @item.comments
    @comment = Comment.new
  end
  def edit
    @item = Item.find(params[:id])
  end



  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      redirect_to :action => "show", :id => item.id
    else
      redirect_to :action => "new"
    end

  end



  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to action: :index
  end
  
  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:price, :description, :title, tag_ids: []).merge(images: uploaded_images)
  end

  def uploaded_images
    params[:item][:images].drop(1).map{|id| ActiveStorage::Blob.find(id)} if params[:item][:images]
  end

  
  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
