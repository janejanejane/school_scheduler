require 'spec_helper'

describe "LectureSessionPages" do
  
	subject { page }

  describe "index" do
  	let(:lecture_session) { FactoryGirl.create(:lecture_session) }

  	before(:all) { 5.times { FactoryGirl.create(:lecture_session) }}
  	after(:all) { LectureSession.delete_all }

  	before { visit lecture_sessions_path }

    it { should have_selector('title', text: full_title('All Classes')) }

    describe "with lecture_session (class) list" do
    	it "should list each lecture_session (class)" do
    		LectureSession.all.each do |class_session|
    			page.should have_selector('div', text: 'Class Name: ' + class_session.name)
    		end
    	end
    end
  end
end
