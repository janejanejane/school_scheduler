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

  belongs_to :teacher
  belongs_to :lecture_session

  validates :teacher_id, presence: :true
  validates :lecture_session_id, presence: :true
  validates :frequency, presence: :true
  validates :start_time, presence: :true
  validates :time_interval, presence: :true, numericality:{ greater_than: 0, less_than_or_equal_to: 60 }

end
