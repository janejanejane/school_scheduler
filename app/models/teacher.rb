# == Schema Information
#
# Table name: teachers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Teacher < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name

  #belongs_to :schedule
  has_many :schedules, dependent: :restrict

  #before_destroy :check_for_teachers

  validates :name, presence: :true

  #private 

	#  def check_for_teachers
	#  	if schedules.count > 0
	#  		errors.add_to_base("Cannot delete schedule while teachers exists")
	#  		return false
	#  	end
	#  end
end
