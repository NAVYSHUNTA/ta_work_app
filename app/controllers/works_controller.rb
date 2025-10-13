class WorksController < ApplicationController
  before_action :authenticate_user! # ログイン必須
  before_action :set_work, only: [ :show, :edit, :update, :destroy ]

  def index
    today = Date.today.to_date
    start_date = Time.current.beginning_of_month.to_date
    end_date = Time.current.end_of_month.to_date
    days_before_month_end = 2.days # 出勤簿の提出が必要なことを月末の数日前から通知するため
    @timesheet_submission_due = current_user.works.exists?(class_date: start_date..end_date) && Time.current.to_date >= end_date - days_before_month_end

    @works = case params[:range]
    when "this month"
      current_user
        .works
        .where(class_date: start_date..end_date)
        .order(:class_date, :start_period)
    else
      current_user
        .works
        .where("class_date >= ?", today)
        .order(:class_date, :start_period)
    end
  end

  def show
  end

  def new
    @work = current_user.works.new(class_date: Date.today.to_date, total_weeks: 7)
  end

  def create
    @work = current_user.works.new(work_params)

    unless @work.valid?
      render :new, status: :unprocessable_entity and return
    end

    total_weeks = work_params[:total_weeks].to_i
    start_dates = [ work_params[:class_date].to_date ]
    start_dates << work_params[:second_class_date].to_date unless work_params[:second_class_date].blank?

    @works = []

    total_weeks.times do |week_index|
      start_dates.each do |start_date|
        class_date = start_date + week_index.weeks

        work = @work.dup
        work.class_date = class_date
        work.save(validate: false)
        @works << work
      end
    end

    redirect_to works_path, notice: "#{@works.size} 件の勤務情報を登録しました"
  end

  def edit
  end

  def update
    apply_to_all_note = params[:work][:apply_to_all_note] == "1"

    if @work.update(work_params)
      if apply_to_all_note
        current_user.works
          .where(subject: @work.subject)
          .where.not(id: @work.id)
          .update_all(note: @work.note)
      end

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
    params
      .require(:work)
      .permit(
        :subject,
        :class_date,
        :second_class_date,
        :total_weeks,
        :status,
        :classroom,
        :start_period,
        :end_period,
        :start_semester,
        :end_semester,
        :content,
        :note
      )
  end
end
