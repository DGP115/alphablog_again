class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    redirect_to post_path(@post)
  end

  def destroy
  end

  private

  def comment_params
    params.expect(comment: [ :body, :post_id, :user_id, :parent_id ])
  end
end
