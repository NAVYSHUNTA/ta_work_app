class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [ :student_number ]

  before_validation :upcase_student_number
  validates :student_number, presence: true, uniqueness: true
  validates :username, presence: true

  has_many :works, dependent: :destroy

  private

  def upcase_student_number
    self.student_number = student_number.upcase if student_number.present?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (student_number = conditions.delete(:student_number))
      where(conditions).where(student_number: student_number.upcase).first
    else
      where(conditions).first
    end
  end
end
