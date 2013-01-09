# == Schema Information
#
# Table name: teachers
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class Teacher < ActiveRecord::Base
  def self.login(username)
    where("name = ?", username)
  end

  # attr_accessible :title, :body
  attr_accessible :name, :password, :password_confirmation

  has_secure_password

  has_many :schedules, dependent: :restrict

  validates :name, presence: :true, uniqueness: { case_sensitive: false }
  validates :password, presence: :true
  validates :password_confirmation, presence: :true

end
