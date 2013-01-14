require 'spec_helper'

describe SchedulesController do

	let(:schedule) { FactoryGirl.create(:schedule) }

  after(:all) { Schedule.delete_all }

  describe "view methods" do

  	before(:all) { FactoryGirl.create(:schedule) }

		describe "GET #index" do
			
			before(:each) { get :index }
			
			it "populates an array of schedules" do
				expect{ assigns(:schedules).should eq([schedule]) }
			end

			it "renders the :index view" do
				response.should render_template :index
			end
		end

		describe "GET #show" do
			
			before(:each) { get :show, id: schedule }
			
			it "assigns the requested schedule to @schedule" do
				assigns(:schedule).should eq(schedule)
			end

			it "renders the :show template" do
				response.should render_template :show
			end
		end

		describe "GET #new" do

			before(:each) { get :new }
			
			it "assigns a new Schedule to @schedule" do
				expect { assigns(:schedule).should eq(Schedule.new) }
			end

			it "renders the :new template" do
				response.should render_template :new
			end
		end

		describe "GET #edit" do

			before(:each) { get :edit, id: schedule }
			
			it "assigns the requested schedule to @schedule" do
				assigns(:schedule).should eq(schedule)
			end

			it "renders the :edit view" do
				response.should render_template :edit
			end
		end
  end

  describe "write methods" do

		let!(:invalid_blank_schedule) { FactoryGirl.attributes_for(:invalid_blank_schedule) }

		describe "POST #create" do
			
			before(:each) { get :new }
					
			describe "with valid attributes" do

				describe "has no schedule overlap" do

					let!(:other_schedule) { FactoryGirl.attributes_for(:schedule) }

					context "when record is new schedule" do
						it "saves in the database" do
							expect{ post :create, schedule: other_schedule  }.to change(Schedule, :count).by(1)
						end
					end

					context "when time_interval precedes recorded schedule" do 
						
						let!(:precede_time_schedule) { FactoryGirl.attributes_for(:precede_time_schedule) }
						it "saves in the database" do
							expect{ post :create, schedule: precede_time_schedule  }.to change(Schedule, :count).by(1)
							other_schedule = precede_time_schedule
						end
					end

					context "when class is new from recorded schedule" do 
					
						let!(:overlap_class_schedule) { FactoryGirl.attributes_for(:overlap_class_schedule) }
						it "does save in database" do
							expect{ post :create, schedule: overlap_class_schedule  }.to change(Schedule, :count).by(1)
							other_schedule = overlap_class_schedule
						end
					end

					it "redirects to the :show template" do
						post :create, schedule: other_schedule
						response.should redirect_to Schedule.last
						flash[:success].should eq("New schedule entry added!")
					end
				end

				describe "has schedule overlap" do
					before { FactoryGirl.create(:default_for_overlap_schedule) }
					
					context "when time_interval is in range of recorded schedule" do 
					
						let!(:overlap_time_schedule) { FactoryGirl.attributes_for(:overlap_time_schedule) }
						it "does not save in database" do
							expect{ post :create, schedule: overlap_time_schedule  }.not_to change(Schedule, :count).by(1)
							flash[:error].should eq("Schedule has an overlap")
						end
					end
				end
			end

			describe "with invalid attributes" do
				it "does not save the new schedule in the database" do
					expect{ post :create, schedule: invalid_blank_schedule }.not_to change(Schedule, :count)
				end

				it "re-renders the :new template" do
					response.should render_template :new
				end
			end
		end

		describe "PUT #update" do

			let!(:updated_schedule) { FactoryGirl.create(:updated_schedule) }

			before(:each) { put :edit, id: schedule }

			describe "with valid attributes" do
				describe "has no schedule overlap" do

					it "saves the updated schedule in the database" do
						expect{ put :update, id: updated_schedule.id, schedule: FactoryGirl.attributes_for(:schedule) }.not_to change(Schedule, :count)
						updated_schedule.reload
						updated_schedule.time_interval.should eq(30)
					end

					it "redirects to the :show template" do
						put :update, id: updated_schedule.id, schedule: FactoryGirl.attributes_for(:schedule)
						response.should redirect_to updated_schedule
						flash[:success].should eq("Schedule updated!")
					end
				end
				
				describe "has schedule overlap" do
					before { FactoryGirl.create(:default_for_overlap_schedule) }
					
					let!(:overlap_time_schedule) { FactoryGirl.attributes_for(:overlap_time_schedule) }
					
					context "when time_interval is in range of recorded schedule" do 
						
						it "does not save in database" do
							expect{ put :update, id: updated_schedule.id, schedule: overlap_time_schedule  }.not_to change(Schedule, :count).by(1)
							flash[:error].should eq("Schedule has an overlap")
						end
					end

					context "when class is same with recorded schedule" do 
					before { FactoryGirl.create(:default_overlap_class_schedule) }
					
						let!(:schedule_class_change) { FactoryGirl.attributes_for(:schedule, lecture_session_id: 2) }
						it "does not save in database" do
							expect{ put :update, id: updated_schedule.id, schedule: schedule_class_change  }.not_to change(Schedule, :count).by(1)
							flash[:error].should eq("Schedule has an overlap")
						end
					end
				end
			end

			describe "with invalid attributes" do
				it "does not save the updated schedule in the database" do
					expect{ put :update, id: updated_schedule.id, schedule: invalid_blank_schedule }.not_to change(Schedule, :count)
				end

				it "re-renders the :edit template" do
					response.should render_template :edit
				end
			end
		end

		describe "DELETE #destroy" do

			before(:each) { get :edit, id: schedule }
			
			it "destroys the requested schedule" do
				expect { delete :destroy, id: schedule.id }.to change(Schedule, :count).by(-1)
			end

			it "redirects to the home page" do
				delete :destroy, id: schedule.id
				response.should redirect_to schedules_url
				flash[:success].should eq("Schedule entry destroyed!")
			end
		end

  end
end
