class WorksController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_work, only: [ :show, :edit, :update, :destroy ]

  def index
    @works = current_user.works.order(:class_date, :start_period)
  end

  def show
  end

  def new
    @work = current_user.works.new(class_date: Date.today, second_class_date: Date.today, total_weeks: 7)
  end

  def create
    @work = current_user.works.new(work_params)

    if @work.valid?
      total_weeks = work_params[:total_weeks].to_i
      start_dates = [ work_params[:class_date], work_params[:second_class_date] ].reject(&:blank?).map(&:to_date).uniq

      @works = []

      total_weeks.times do |week_index|
        start_dates.each do |start_date|
          class_date = start_date + week_index.weeks
          @works << current_user.works.create(
            work_params.merge(class_date: class_date)
          )
        end
      end

      redirect_to works_path, notice: "#{@works.size} 件の勤務情報を登録しました"
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
    params.require(:work).permit(:subject, :class_date, :second_class_date, :total_weeks, :status, :classroom, :start_period, :end_period, :start_semester, :end_semester, :content)
  end
end
