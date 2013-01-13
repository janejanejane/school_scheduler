require 'spec_helper'

describe "TeacherPages" do
  
	subject { page }

  describe "index" do
  	let(:teacher) { FactoryGirl.create(:teacher) }

    before(:all) { 5.times { FactoryGirl.create(:teacher) } }
    after(:all) { Teacher.delete_all }

  	before { visit teachers_path }

    it { should have_selector('title', text: full_title('All Teachers')) }

    describe "with teacher list" do
	    it "should list each teacher" do
	    	Teacher.all.each do |te|
	    		page.should have_selector('div', text: 'Teacher Name: ' + te.name)
	    	end
	    end
	  end
  end
end
