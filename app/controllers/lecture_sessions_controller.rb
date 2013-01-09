class LectureSessionsController < ApplicationController
	rescue_from ActiveRecord::DeleteRestrictionError, :with => :has_dependency

	before_filter :signed_in_teacher

	def index
		logger.debug "inside INDEX"
		@classes = LectureSession.all
	end

	def show
		logger.debug "inside SHOW"
		@class = LectureSession.find(params[:id])
	end

	def new
		logger.debug "inside NEW"
		@class = LectureSession.new
	end

	def create
		logger.debug "inside CREATE"
		@class = LectureSession.new(params[:lecture_session])

		if @class.save
			flash[:success] = "New class entry added!"
			redirect_to @class
		else
			render 'new'
		end
	end

	def edit
		logger.debug "inside EDIT"
		@class = LectureSession.find(params[:id])
	end

	def update
		logger.debug "inside UPDATE"
		@class = LectureSession.find(params[:id])
		if @class.update_attributes(params[:class])
			redirect_to @class
		else
			render 'edit'
		end
	end

	def destroy
		logger.debug "inside DESTROY"
		LectureSession.find(params[:id]).destroy
		flash[:success] = "Class entry destroyed!"
		redirect_to lecture_sessions_path
	end

	private 

		def has_dependency 
			flash[:error] = "Cannot delete class record because of dependent schedule(s)!"
			redirect_to :root
		end

		def signed_in_teacher
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end
end
