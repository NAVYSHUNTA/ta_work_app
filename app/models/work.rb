class Work < ApplicationRecord
  belongs_to :user

  # 未着手: 0, 出勤: 1, 欠勤: 2, 休講: 3, 補講: 4
  enum :status, { not_started: 0, present: 1, absent: 2, cancelled: 3, makeup: 4 }
  enum :start_semester, { "1Q": 1, "2Q": 2, "3Q": 3, "4Q": 4 }
  enum :end_semester,   { "1Q": 1, "2Q": 2, "3Q": 3, "4Q": 4 }

  validates :subject, :class_date, :status, :classroom, :period, :start_semester, :end_semester, presence: true
  validate :semester_range_valid

  STATUS_LABELS = {
    not_started: "未着手",
    present:     "出勤",
    absent:      "欠勤",
    cancelled:  "休講",
    makeup:      "補講",
  }.freeze

  def status_jp
    STATUS_LABELS[status.to_sym]
  end

  private

  def semester_range_valid
    return if start_semester.blank? || end_semester.blank?

    if start_semester > end_semester
      errors.add(:end_semester, "は開始学期より前にできません")
    end
  end
end
