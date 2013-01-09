class SessionsController < ApplicationController
	def new

	end

	def create
		teacher = Teacher.login(params[:session][:name].downcase)[0] # get first object; returns ActiveRecord::Relation (collection of objects)

		if teacher # get first object
			if teacher.authenticate(params[:session][:password])
				sign_in teacher
				redirect_back_or teacher
			end
		else
			flash.now[:error] = "Invalid name/password combination"
			render 'new'
		end
	end

	def destory
		sign_out
		redirect_to root_url
	end
end
