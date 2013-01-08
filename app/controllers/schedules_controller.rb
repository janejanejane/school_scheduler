class SchedulesController < ApplicationController
	# private methods are loaded
	before_filter :correct_schedule, only: [:edit, :update, :show]
	before_filter :format_frequency, only: [:create, :update]

	def index
		logger.debug "inside INDEX"
		@schedules = Schedule.all
		@teachers = Teacher.all
		@classes = LectureSession.all
	end

	def show
		logger.debug "inside SHOW"
		#@schedule = Schedule.find(params[:id])
	end

	def new
		logger.debug "inside NEW"
		@schedule = Schedule.new
	end

	def create
		logger.debug "inside CREATE"
		@schedule = Schedule.new(params[:schedule])

		if @schedule.save
			flash[:success] = "New schedule entry added!"
			redirect_to @schedule
		else
			render 'new'
		end
	end

	def edit
		logger.debug "inside EDIT"
		#@schedule = Schedule.find(params[:id])
		@dates = @schedule.frequency.split(',')
	end

	def update
		logger.debug "inside UPDATE"
		#@schedule = Schedule.find(params[:id])
		if @frequency != ''
			@dates = @frequency.split(',')
		end

		if @schedule.update_attributes(params[:schedule])
			redirect_to @schedule
		else
			render 'edit'
		end
	end

	def destroy
		logger.debug "inside DESTROY"
		Schedule.find(params[:id]).destroy
		flash[:success] = "Schedule entry destroyed!"
		redirect_to schedules_path
	end

	private
		def correct_schedule
			@schedule = Schedule.find(params[:id])
      #redirect_to(root_path) unless current_user?(@user)
    end

		def format_frequency
			logger.debug "inside format_frequency"

			if(!params[:schedule][:frequency].nil?)
				@frequency = params[:schedule][:frequency].join(',')
			else
				@frequency = ''
			end
			
			params[:schedule][:frequency] = @frequency
		end
end
