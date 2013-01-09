require 'spec_helper'

describe SchedulesController do
	describe "GET #index" do
		it "populates an array of schedules"
		it "renders the :index view"
	end

	describe "GET #show" do
		it "assigns the requested schedule to @schedule"
		it "renders the :show template"
	end

	describe "GET #new" do
		it "assigns a new Schedule to @schedule"
		it "renders the :new template"
	end

	describe "POST #create" do
		context "with valid attributes" do
			it "saves the new schedule in the database"
			it "redirects to the :show template"
		end

		context "with invalid attributes" do
			it "does not save the new schedule in the database"
			it "re-renders the :new template"
		end
	end

	describe "GET #edit" do
		it "assigns the requested schedule to @schedule"
		it "renders the :edit view"
	end

	describe "PUT #update" do
		context "with valid attributes" do
			it "saves the updated schedule in the database"
			it "redirects to the :show template"
		end

		context "with invalid attributes" do
			it "does not save the updated schedule in the database"
			it "re-renders the :edit template"
		end
	end

	describe "DELETE #destroy" do
		it "destroys the requested schedule"
		it "redirects to the home page"
	end
end
