class Work < ApplicationRecord
  belongs_to :user

  attr_accessor :total_weeks, :second_class_date

  # 未着手: 0, 出勤: 1, 欠勤: 2, 休講: 3, 補講: 4
  enum :status, { not_started: 0, present: 1, absent: 2, cancelled: 3, makeup: 4 }
  enum :start_semester, { start_1Q: 1, start_2Q: 2, start_3Q: 3, start_4Q: 4 }
  enum :end_semester,   { end_1Q: 1, end_2Q: 2, end_3Q: 3, end_4Q: 4 }

  validates :subject, :class_date, :status, :classroom, :start_period, :end_period, :start_semester, :end_semester, presence: true
  validate :semester_range_valid, :period_range_valid
  validate :different_weekdays_for_class_dates, on: :create

  STATUS_LABELS = {
    not_started: "未着手",
    present:     "出勤",
    absent:      "欠勤",
    cancelled:   "休講",
    makeup:      "補講"
  }.freeze

  SEMESTER_LABELS = {
    start_1Q: "1Q",
    start_2Q: "2Q",
    start_3Q: "3Q",
    start_4Q: "4Q",
    end_1Q: "1Q",
    end_2Q: "2Q",
    end_3Q: "3Q",
    end_4Q: "4Q"
  }

  def status_jp
    STATUS_LABELS[status.to_sym]
  end

  def start_semester_str
    return if start_semester.blank?

    SEMESTER_LABELS[start_semester.to_sym]
  end

  def end_semester_str
    return if end_semester.blank?

    SEMESTER_LABELS[end_semester.to_sym]
  end

  def period_range
    if start_period == end_period
      "#{start_period} 限"
    else
      "#{start_period} 限から #{end_period} 限まで"
    end
  end

  def semester_period
    if start_semester_str == end_semester_str
      start_semester_str
    elsif start_semester_str == "1Q" && end_semester_str == "4Q"
      "通年"
    elsif start_semester_str == "1Q" && end_semester_str == "2Q"
      "前期"
    elsif start_semester_str == "3Q" && end_semester_str == "4Q"
      "後期"
    else
      "#{start_semester_str} から #{end_semester_str} まで"
    end
  end

  private

  def semester_range_valid
    return if start_semester.blank? || end_semester.blank?

    if Work.start_semesters[start_semester] > Work.end_semesters[end_semester]
      errors.add(:end_semester, "は開始学期より前にできません")
    end
  end

  def period_range_valid
    return if start_period.blank? || end_period.blank?

    if start_period > end_period
      errors.add(:end_period, "は開始時限より前にできません")
    end
  end

  def different_weekdays_for_class_dates
    return if class_date.blank? || second_class_date.blank?

    begin
      date = class_date.to_date
      second_date = second_class_date.to_date
    rescue ArgumentError
      return
    end

    if date.wday == second_date.wday
      errors.add(:base, "授業日が同じ曜日になっています（週 2 回の場合は相異なる曜日を選んでください）")
    end
  end
end
