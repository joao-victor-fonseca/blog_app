class CommentsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]
    before_action :set_post, only: [:create, :destroy]
    before_action :set_comment, only: [:destroy]
  
    # POST /posts/:post_id/comments
    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        redirect_to @post, notice: 'Comentário publicado com sucesso!'
      else
        redirect_to @post, alert: 'Falha ao publicar comentário.'
      end
    end
  
    # DELETE /posts/:post_id/comments/:id
    def destroy
      @comment.destroy
      redirect_to @post, notice: 'Comentário excluído com sucesso!'
    end
  
    private
  
    # Definir o post
    def set_post
      @post = Post.friendly.find(params[:post_id])
    end
  
    # Definir o comentário
    def set_comment
      @comment = @post.comments.find(params[:id])
    end
  
    # Strong parameters
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  