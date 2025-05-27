class SearchController < ApplicationController
  def index
    @query = Post.ransack(params[:q])
    # @posts = @query.result(distinct: true).includes(:user, :categories, :comments)
    @posts = @query.result(distinct: true)
  end
end
