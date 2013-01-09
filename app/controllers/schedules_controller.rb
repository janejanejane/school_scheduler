class SchedulesController < ApplicationController
	# private methods are loaded
	before_filter :correct_schedule, only: [:edit, :update, :show]
	before_filter :format_frequency, only: [:create, :update]
	before_filter :split_frequency, only: [:create, :update]
	before_filter :is_valid_schedule, only: [:create, :update]
	before_filter :signed_in_teacher

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
		
		if is_valid_schedule
			if @schedule.save
				flash[:success] = "New schedule entry added!"
				redirect_to @schedule
			else
				render 'new'
			end
		else
			flash.now[:error] = "Schedule has an overlap"
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
		
		if is_valid_schedule
			if @schedule.update_attributes(params[:schedule])
				redirect_to @schedule
			else
				render 'edit'
			end
		else
			flash.now[:error] = "Schedule has an overlap"
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

		def split_frequency
			if @frequency != ''
				@dates = @frequency.split(',')
			end
		end

		def is_valid_schedule
			logger.debug "inside is_valid_schedule"

			# get values entered by user
			proposed_class_name = params[:schedule][:lecture_session_id]
			proposed_start_hr = params[:schedule]["start_time(4i)"]
			proposed_start_min = params[:schedule]["start_time(5i)"]
			proposed_class_start = DateTime.parse("2000-01-01 " + proposed_start_hr + ":" + proposed_start_min).to_i
			proposed_class_end = proposed_class_start
			if params[:schedule][:time_interval] != ""
				proposed_class_end = (proposed_class_start + params[:schedule][:time_interval].to_i.minutes).to_i
			end

			@results = Schedule.where('teacher_id = ?', params[:schedule][:teacher_id])

			# get values from database for this teacher
			@results.each do |sched| # saved record for this teacher
					class_name = sched.lecture_session_id
					class_start = sched.start_time
					class_end = (class_start + sched.time_interval.minutes).to_i
					class_start = class_start.to_i
					class_frequency = sched.frequency.split(',')

					class_frequency.each do |day|
						if(@dates) # from params[:schedule][:frequency] converted to array
							if(@dates.index{|d| d == day}) # checks if index is not 0
									logger.debug "class name " + proposed_class_name.to_s + " " + class_name.to_s
									logger.debug class_name === proposed_class_name.to_i
								if(class_name === proposed_class_name.to_i)
									logger.debug "same name " + proposed_class_name.to_s + " " + class_name.to_s
									if((class_start..class_end).include?(proposed_class_start) || (class_start..class_end).include?(proposed_class_end)) # if range include the number
										logger.debug "invalid schedule"
										return false
									else
										logger.debug "not in range"
										return true
									end
								else
									logger.debug "different class name " + proposed_class_name.to_s + " " + class_name.to_s
									return true
								end
							else
								logger.debug "date not in array"
								return true
							end
		    		end
					end
			end
		end

		def signed_in_teacher
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end
end
