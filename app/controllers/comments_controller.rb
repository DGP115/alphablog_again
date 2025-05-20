class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
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
end
