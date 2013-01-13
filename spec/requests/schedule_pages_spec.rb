require 'spec_helper'

describe "SchedulePages" do

	subject { page }

  describe "index" do
  	let(:schedule) { FactoryGirl.create(:schedule) }
  	let(:count) { Schedule.count }

  	before { visit root_path }

    it { should have_selector('title', text: full_title('All Schedules')) }
    it { should have_selector('h1', text: "#{count}") }
  end
end
