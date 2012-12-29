# == Schema Information
#
# Table name: schedules
#
#  id                 :integer          not null, primary key
#  teacher_id         :integer
#  lecture_session_id :integer
#  frequency          :string(255)
#  start_time         :time
#  time_interval      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Schedule < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :teacher_id, :lecture_session_id, :frequency, :start_time, :time_interval

  has_many :teachers, dependent: :destroy
  has_many :lecture_sessions, dependent: :destroy

  validates :teacher_id, presence: :true
  validates :lecture_session_id, presence: :true
  validates :frequency, presence: :true
  validates :start_time, presence: :true
  validates :time_interval, presence: :true
end
