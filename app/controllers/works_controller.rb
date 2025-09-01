class WorksController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_work, only: [ :show, :edit, :update, :destroy ]

  def index
    @works = current_user.works.order(:class_date, :start_period)
  end

  def show
  end

  def new
    @work = current_user.works.new
  end

  def create
    @work = current_user.works.new(work_params)
    if @work.save
      redirect_to works_path, notice: "勤務情報を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @work.update(work_params)
      redirect_to works_path, notice: "勤務情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work.destroy
    redirect_to works_path, notice: "勤務情報を削除しました"
  end

  private

  def set_work
    @work = current_user.works.find(params[:id])
  end

  def work_params
    params.require(:work).permit(:subject, :class_date, :status, :classroom, :start_period, :end_period, :start_semester, :end_semester)
  end
end
