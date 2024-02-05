class PrototypesController < ApplicationController
  before_action :get_prototype, only: %i[show edit update]
  before_action :authenticate_user!, only: %i[new edit destroy]

  def index
    # @prototypes = Prototype.all（N+1問題対応
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    # 更新結果取得の為にnew（外部キーはマージ済
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      # 422エラーを投げる
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # before_actionで@prototypeを取得
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    # URL直入力で投稿者以外の編集ページに移動させない
    if current_user.id != @prototype.user.id
      redirect_to root_path
    end
  end

  def update
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      # 編集内容を維持するため、@prototypeとしておく
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  # パラメータのidよりprototypeを取得
  def get_prototype
    @prototype = Prototype.find(params[:id])
  end

end
