# == Schema Information
#
# Table name: lecture_sessions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LectureSession < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name

  belongs_to :schedule

  validates :name, presence: :true
end
