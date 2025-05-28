class SearchController < ApplicationController
  def index
    # Use the ransack gem to define the search query based on the ransack method defined
    # in each relevant model
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @posts = Post.none
    else
      @query = Post.ransack(params[:q])

      # @posts = @query.result(distinct: true).includes(:user, :categories, :comments)
      @posts = @query.result(distinct: true)
    end
  end

  def clear
    @query = Post.ransack(params[nil])
    @posts = Post.none
    redirect_to search_path
  end
end
