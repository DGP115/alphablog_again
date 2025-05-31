class PostsController < ApplicationController
  # NOTE:  These before_action methods execute in the order given, so order here is important
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :require_user, except: %i[ show index ]
  before_action :require_same_user, only: %i[ edit update destroy ]
  def index
    @posts = Post.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def show
    # In preparation for showing the hierarchical comments for a post:
    @comments = @post.comments.arrange
    # Update counter that the notification for this post has been read
    mark_notifications_as_read
  end

  def edit
    # Nothing to do here since set_post is already run as a before_action
  end

  def new
    @post = Post.new
  end

  def create
    #  Rails is smart enough to extract from the white-listed params hash the title and body
    #  needed to create the new post.
    @post = Post.new(whitelist_params)
    @post.user = current_user
    if @post.save
      flash[:notice]="Post created successfully."
      redirect_to post_path(@post)
    else
      # Error trapping
      # Re-render the "new" article page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render "new", status: :unprocessable_entity
    end
  end

  def update
    #  Rails is smart enough to extract from the white-listed params hash the title and body
    #  needed to create the new post.
    if @post.update(whitelist_params)
      flash[:notice]="Post updated successfully."
      redirect_to post_path(@post)
    else
      # Error trapping
      # Re-render the "new" post page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      flash[:notice]="Post deleted."
      redirect_to user_path(@post.user)
    else
      # Error trapping
      # Re-render the "edit" post page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def whitelist_params
    params.expect(post: [ :title, :body, category_ids: [] ])
  end

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    flash[:alert] = "#{e.message}"
    redirect_to posts_path
  end

  def require_same_user
    if current_user != @post.user && !current_user.admin?
      flash[:alert] = "You can only modify your own posts"
      redirect_to @post
    end
  end

  def mark_notifications_as_read
    if current_user
      notifications_to_mark_as_read = @post.notifications.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
