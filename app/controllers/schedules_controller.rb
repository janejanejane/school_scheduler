class SchedulesController < ApplicationController
	def index
		@schedules = Schedule.all
		@teachers = Teacher.all
		@classes = LectureSession.all
	end

	def show
		@schedule = Schedule.find(params[:id])
	end

	def new
		@schedule = Schedule.new
	end

	def create
		@schedule = Schedule.new(params[:schedule])

		if @schedule.save
			flash[:success] = "New schedule entry added!"
			redirect_to @schedule
		else
			render 'new'
		end
	end

	def edit
		@schedule = Schedule.find(params[:id])
	end

	def update
		@schedule = Schedule.find(params[:id])
		if @schedule.update_attributes(params[:schedule])
			redirect_to @schedule
		else
			render 'edit'
		end
	end

	def destroy
		#begin
			@schedule = Schedule.find(params[:id]).destroy
		#rescue
			#ActiveRecord::DeleteRestrictionError => err
			flash[:error] = err
			#@schedule.errors.add(:base, err)
			flash[:success] = "Schedule entry destroyed!"
			redirect_to schedules_path
		#end
	end
end
