class Work < ApplicationRecord
  belongs_to :user

  # 未着手: 0, 出勤: 1, 欠勤: 2, 休講: 3, 補講: 4
  enum :status, { not_started: 0, present: 1, absent: 2, cancelled: 3, makeup: 4 }
  enum :start_semester, { start_1Q: 1, start_2Q: 2, start_3Q: 3, start_4Q: 4 }
  enum :end_semester,   { end_1Q: 1, end_2Q: 2, end_3Q: 3, end_4Q: 4 }

  validates :subject, :class_date, :status, :classroom, :period, :start_semester, :end_semester, presence: true
  validate :semester_range_valid

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

  private

  def semester_range_valid
    return if start_semester.blank? || end_semester.blank?

    if start_semester > end_semester
      errors.add(:end_semester, "は開始学期より前にできません")
    end
  end
end
