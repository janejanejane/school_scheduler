class TeachersController < ApplicationController
	def index
		@teachers = Teacher.all
	end

	def show
		@teacher = Teacher.find(params[:id])
	end

	def new
		@teacher = Teacher.new
	end

	def create
		@teacher = Teacher.new(params[:teacher])

		if @teacher.save
			flash[:success] = "New teacher entry added!"
			redirect_to @teacher
		else
			render 'new'
		end
	end

	def edit
		@teacher = Teacher.find(params[:id])
	end

	def update
		@teacher = Teacher.find(params[:id])
		if @teacher.update_attributes(params[:teacher])
			redirect_to @teacher
		else
			render 'edit'
		end
	end

	def destroy
		Teacher.find(params[:id]).destroy
		flash[:success] = "Teacher entry destroyed!"
		redirect_to teachers_path
	end
end
