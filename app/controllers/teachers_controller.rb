class TeachersController < ApplicationController
	rescue_from ActiveRecord::DeleteRestrictionError, :with => :has_dependency

	before_filter :auto_pass, only: [:create]

	def index
		logger.debug "inside INDEX"
		@teachers = Teacher.all
	end

	def show
		logger.debug "inside SHOW"
		@teacher = Teacher.find(params[:id])
		@classes = LectureSession.all
		@schedule = @teacher.schedules.build
	end

	def new
		logger.debug "inside NEW"
		@teacher = Teacher.new
	end

	def create
		logger.debug "inside CREATE"
		@teacher = Teacher.new(params[:teacher])

		if @teacher.save
			flash[:success] = "New teacher entry added!"
			redirect_to @teacher
		else
			render 'new'
		end
	end

	def edit
		logger.debug "inside EDIT"
		@teacher = Teacher.find(params[:id])
	end

	def update
		logger.debug "inside UPDATE"
		@teacher = Teacher.find(params[:id])
		if @teacher.update_attributes(params[:teacher])
			redirect_to @teacher
		else
			render 'edit'
		end
	end

	def destroy
		logger.debug "inside DESTROY"
		Teacher.find(params[:id]).destroy
		flash[:success] = "Teacher entry destroyed!"
		redirect_to teachers_path
	end

	private 

		def has_dependency 
			flash[:error] = "Cannot delete teacher record because of dependent schedule(s)!"
			redirect_to :root
		end

		def auto_pass
			params[:teacher][:password] = "P@ssw0rd"
			params[:teacher][:password_confirmation] = "P@ssw0rd"
		end
end
