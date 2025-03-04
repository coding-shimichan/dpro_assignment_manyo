class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :correct_user, only: [ :show, :edit, :update, :destroy ]

  # GET /tasks or /tasks.json
  def index
    if (params[:search].present? && params[:search][:label].present?)
      @tasks = current_user.labels.find(params[:search][:label]).tasks.search_and_sort(params).page(params[:page])
    else
      @tasks = current_user.tasks.search_and_sort(params).page(params[:page])
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        flash[:notice] = t(".created")
        format.html { redirect_to tasks_path }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        flash[:notice] = t(".updated")
        format.html { redirect_to task_url(@task) }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      flash[:notice] = t(".destroyed")
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, :user_id, label_ids: [])
    end

    def correct_user
      set_task

      if (current_user?(User.find(@task.user_id)) == false)
        flash[:alert] = t("errors.messages.incorrect_user")
        redirect_to tasks_path
      end
    end
end
