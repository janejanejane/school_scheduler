class SchedulesController < ApplicationController
	# private methods are loaded
	#before_filter :combined_start_time, only: [:create, :update]
	before_filter :correct_schedule, only: [:edit, :update, :show]
	before_filter :format_frequency, only: [:create, :update]
	before_filter :split_frequency, only: [:create, :update]
	#before_filter :is_valid_schedule, only: [:create, :update]
	#before_filter :signed_in_teacher

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
		logger.debug "before save: " +  @schedule.inspect
		
		if is_valid_schedule
			if @schedule.save
				logger.debug "after save: " +  @schedule.inspect
				flash[:success] = "New schedule entry added!"
				redirect_to @schedule
				logger.debug "redirect_to @schedule: " +  (Schedule.find(@schedule.id)).frequency.inspect
			else
				logger.debug "render new"
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
				flash[:success] = "Schedule updated!"
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

		#def combined_start_time
  	#	params[:schedule].parse_time_select! :start_time
		#end

		def correct_schedule
			@schedule = Schedule.find(params[:id])
      #redirect_to(root_path) unless current_user?(@user)
    end

		def format_frequency
			logger.debug "inside format_frequency"
			logger.debug "params: " + params.to_s

			if(!params[:schedule][:frequency].nil?)
				@frequency = params[:schedule][:frequency].join(',')
			else
				@frequency = ''
			end
			
			params[:schedule][:frequency] = @frequency
			# logger.debug "params[:schedule][:frequency]: " + params[:schedule][:frequency]
		end

		def split_frequency
			logger.debug "inside split_frequency"
			if @frequency != ''
				@dates = @frequency.split(',')
			end
			logger.debug @dates
		end

		def is_valid_schedule
			logger.debug "inside is_valid_schedule"
			logger.debug "params[:schedule]: " + params[:schedule].to_s

			# get values entered by user
			proposed_class_name = params[:schedule][:lecture_session_id]
			
			proposed_class_start = "00"
			logger.debug "(!proposed_start = params[:schedule][:start_time].nil?): " + (!proposed_start = params[:schedule][:start_time].nil?).to_s
			if(!proposed_start = params[:schedule][:start_time].nil?)
				proposed_class_start = DateTime.parse(params[:schedule][:start_time]).to_i
			else				
				proposed_start_hr = "00"
				if(!params[:schedule]["start_time(4i)"].nil?)
					proposed_start_hr = params[:schedule]["start_time(4i)"]
				end

				proposed_start_min = "00"
				if(!params[:schedule]["start_time(5i)"].nil?)
					proposed_start_min = params[:schedule]["start_time(5i)"]
				end

				proposed_class_start = DateTime.parse("2000-01-01 " + proposed_start_hr + ":" + proposed_start_min).to_i
			end

			proposed_class_end = proposed_class_start
			proposed_time_interval = params[:schedule][:time_interval]

			if(proposed_time_interval != "")
				proposed_class_end = (proposed_class_start + proposed_time_interval.to_i.minutes).to_i
			end

			logger.debug "PROPOSED CLASS START: " + proposed_class_start.to_s + " PROPOSED CLASS END: " + proposed_class_end.to_s
			logger.debug "START: " + proposed_start.class.to_s + "CLASS START: " + proposed_class_start.to_s + "CLASS END: " + proposed_class_end.to_s

			@results = Schedule.where('teacher_id = ?', params[:schedule][:teacher_id])
			logger.debug "TEACHER: " + @results.inspect

			@results_copy = Array.new(@results)
			if(!params[:id].nil?)
				idx = 0
				for sched in @results_copy do
					# logger.debug "SCHED INSIDE @results_copy: " + sched.inspect
					# logger.debug "INSIDE @results_copy sched.id: " + sched.id.to_s + " INDEX: " + @results_copy.index(sched).to_s
					# logger.debug "INSIDE @results_copy params[:id]: " + params[:id].to_s
					# logger.debug "(sched.id.to_i == params[:id].to_i): " + (sched.id.to_i == params[:id].to_i).to_s
					if(sched.id.to_i == params[:id].to_i)
						logger.debug "INDEX INSIDE @results_copy: " + @results_copy.index(sched).to_s
						idx = @results_copy.index(sched)
					end
				end
				@results_copy.delete_at(idx)
			end

			logger.debug "TEACHER: " + @results_copy.inspect

			if(@results_copy.count > 0)
				# get values from database for this teacher
				@results_copy.each do |sched| # saved record for this teacher
					class_name = sched.lecture_session_id
					class_start = sched.start_time
					class_end = (class_start + sched.time_interval.minutes).to_i
					class_start = (class_start).to_i
					class_frequency = sched.frequency.split(',')

					# logger.debug "class_frequency:" + class_frequency.to_s
					# logger.debug "@dates: " + @dates.to_s

					class_frequency.each do |day|
						if(@dates) # from params[:schedule][:frequency] converted to array
							if(@dates.index{|d| d == day}) # checks if index is not 0
								# logger.debug "class name " + proposed_class_name.to_s + " " + class_name.to_s
								# logger.debug class_name === proposed_class_name.to_i
								# logger.debug "same name " + proposed_class_name.to_s + " " + class_name.to_s
								# logger.debug "class_start: " + class_start.to_s + " class_end: " + class_end.to_s + " for schedule: " + sched.id.to_s
								if(class_start == proposed_class_end)
									logger.debug "class_start == proposed_class_end" + (class_start == proposed_class_end).to_s
									return true
								else
									# logger.debug "proposed_class_start range: " + (class_start..class_end).include?(proposed_class_start).to_s
									# logger.debug "proposed_class_end range: " + (class_start..class_end).include?(proposed_class_end).to_s
									if((class_start..class_end).include?(proposed_class_start) || (class_start..class_end).include?(proposed_class_end)) # if range include the number
										logger.debug "invalid schedule"
										return false
									else
										logger.debug "not in range"
										return true
									end
								end
							else
								logger.debug "date not in array"
								return true
							end
		    		end
					end
				end
			end
			return true
		end

		def signed_in_teacher
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end
end
