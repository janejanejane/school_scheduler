require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SchedulesHelper. For example:
#
# describe SchedulesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe SchedulesHelper do
	describe "pluralize schedule" do
  	if(Schedule.count > 0)
			it { pluralize(1, "schedule").should == "1 schedule" }
		else
			it { pluralize(0, "schedule").should == "0 schedules" }
    end    
	end  
end
