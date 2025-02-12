class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    comment = @commentable.comments.build(comment_params)
    comment.user_id = current_user.id
    if comment.save
      flash[:success] = "コメントしました"
    else
      flash[:danger] = "コメントできませんでした"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @comment = Comment.find(params[:id])
  
    if @comment.user == current_user
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    else
      flash[:alert] = "削除権限がありません"
    end
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to item_path(@comment.commentable) }
    end
  end
  
  def edit
    @item = @comment.commentable
  end



  def update
    if @comment.update(comment_params)
      redirect_to item_path(@comment.commentable), notice: "コメントを更新しました"
    else
      flash[:alert] = "コメントの更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      redirect_to root_path, alert: "コメントが見つかりません"
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
