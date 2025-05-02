class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update show destroy ]
  before_action :require_user, only: %i[ edit update destroy ]
  #
  def new
    @category = Category.new
  end

  def create
    #  Rails is smart enough to extract from the white-listed params hash the title and body
    #  needed to create the new post.
    @category = Category.new(whitelist_params)
    if @category.save
      flash[:notice]="Category: #{@category.name} created successfully."
      redirect_to categories_path
    else
      # Error trapping
      # Re-render the "new" category page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(whitelist_params)
      flash[:notice]="Category: #{@category.name} updated successfully."
      redirect_to categories_path
    else
      # Error trapping
      # Re-render the "edit" page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render "edit", status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5).order(name: :asc)
  end

  def show
  end

  def destroy
  end

  private

  def whitelist_params
    params.expect(category: [ :name, :description ])
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
