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

  #belongs_to :schedule
  has_many :schedules, dependent: :restrict

  #before_destroy :check_for_classes

  validates :name, presence: :true

  #private 

	#  def check_for_classes
	#  	if schedules.count > 0
	#  		errors.add_to_base("Cannot delete schedule while classes exists")
	#  		return false
	#  	end
	#  end
end
