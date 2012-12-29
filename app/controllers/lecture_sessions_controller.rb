class LectureSessionsController < ApplicationController
	rescue_from ActiveRecord::DeleteRestrictionError, :with => :has_dependency

	def index
		@classes = LectureSession.all
	end

	def show
		@class = LectureSession.find(params[:id])
	end

	def new
		@class = LectureSession.new
	end

	def create
		@class = LectureSession.new(params[:lecture_session])

		if @class.save
			flash[:success] = "New class entry added!"
			redirect_to @class
		else
			render 'new'
		end
	end

	def edit
		@class = LectureSession.find(params[:id])
	end

	def update
		@class = LectureSession.find(params[:id])
		if @class.update_attributes(params[:class])
			redirect_to @class
		else
			render 'edit'
		end
	end

	def destroy
		LectureSession.find(params[:id]).destroy
		flash[:success] = "Class entry destroyed!"
		redirect_to lecture_sessions_path
	end

	private 

		def has_dependency 
			flash[:error] = "Cannot delete class record because of dependent schedule(s)!"
			redirect_to :root
		end
end
