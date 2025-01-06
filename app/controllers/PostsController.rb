class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(3)
  end

  # GET /posts/:id
  def show
    @comments = @post.comments.order(created_at: :asc)
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # POST /posts
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/edit
  def edit
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post excluído com sucesso!'
  end

  private

  # Strong parameters
  def post_params
    params.require(:post).permit(:title, :content, tag_ids: [])
  end

  # Find the post by ID or slug
  def set_post
    @post = Post.friendly.find(params[:id])
  end

  # Ensure the current user owns the post
  def authorize_user!
    unless @post.user == current_user
      redirect_to posts_path, alert: 'Você não tem permissão para realizar essa ação.'
    end
  end
end
