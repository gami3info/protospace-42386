class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  def index
      @prototypes = Prototype.all
  end
  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit; end

  def update
    if @prototype.update(prototype_params)
       redirect_to prototype_path(@prototype)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path
  end

  private

  def authorize_user
    redirect_to root_path unless @prototype.user == current_user
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end