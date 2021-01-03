class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [ :edit, :show, :update, :destroy ]


  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      # ログイン中ユーザーのタスクのみを表示
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(10)
    end
  end

  def create
    # ログイン中ユーザーのタスクを作成
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      # インスタンスを持ってtasks#showへリダイレクト
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが正常に登録されませんでした'
      # 再びtasks#newを表示
      render :new
    end
  end
  

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが正常に更新されませんでした'
      render :edit
    end
  end
  

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
    # アクション実行ページへ戻る
    # 戻るべきページがない場合にはroot_pathに戻る
    redirect_back(fallback_location: root_path)
  end


  private

  def task_params
    params.require(:task).permit(:content,:status)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end

