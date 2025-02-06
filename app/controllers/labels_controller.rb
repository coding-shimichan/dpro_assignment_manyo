class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  def index
    @labels = current_user.labels
  end

  def show
  end
  
  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.build(label_params)

    respond_to do |format|
      if @label.save
        flash[:notice] = t(".created")
        format.html { redirect_to labels_path }
        format.json { render :show, status: :created, location: @label }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @label.update(label_params)
        flash[:notice] = t(".updated")
        format.html { redirect_to labels_path }
        format.json { render :show, status: :ok, location: @label }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @label.destroy

    respond_to do |format|
      flash[:notice] = t(".destroyed")
      format.html { redirect_to labels_url }
      format.json { head :no_content }
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name, :user_id)
  end
end
