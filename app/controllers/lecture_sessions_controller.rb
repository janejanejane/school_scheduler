class LectureSessionsController < ApplicationController
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
		LectureSession.find(params[:lecture_session]).destroy
		flash[:success] = "Class entry destroyed!"
		redirect_to lecture_sessions_path
	end
end
