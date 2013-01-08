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

  has_many :schedules, dependent: :restrict

  validates :name, presence: :true, uniqueness: { case_sensitive: false }

end
