class CommentsController < ApplicationController
  before_action :set_post, only: %i[ create edit update destroy ]
  before_action :set_comment, only: %i[ edit update destroy]
  before_action :check_for_cancel, only: %i[ update ]
  def create
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      flash[:notice]="Comment updated successfully."
      redirect_to post_path(@post)
    else
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = "Comment deleted successfully."
    else
      flash[:alert] = "Failed to delete comment."
    end
    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.expect(comment: [ :body, :post_id, :user_id, :parent_id ])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def check_for_cancel
    if params[:button] == "cancel"
      redirect_to post_path(@post)
    end
  end
end
