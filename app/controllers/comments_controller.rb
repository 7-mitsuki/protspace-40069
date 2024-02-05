class CommentsController < ApplicationController
  def create
    # renderを行うためインスタンス変数とする
    @prototype = Prototype.find(params[:prototype_id])
    @comment = @prototype.comments.new(comment_params)
    if @comment.save
      # redirectする場合は、prototype#show先でインスタンス変数が生成されるが...
      redirect_to prototype_path(@prototype)
    else
      # renderは表示するコントローラを経由しないのだ
      render 'prototypes/show', status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
