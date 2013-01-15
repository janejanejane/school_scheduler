class SessionsController < ApplicationController
	def new

	end

	def create
		logger.debug "inside Sessions CREATE"
		teacher = Teacher.login(params[:session][:name].downcase)[0] # get first object; returns ActiveRecord::Relation (collection of objects)

		logger.debug teacher
		if teacher # get first object
			if teacher.authenticate(params[:session][:password])
				#sign_in teacher
				session[:remember_token] = teacher
				#redirect_back_or teacher
				redirect_to root_url
			end
		else
			flash.now[:error] = "Invalid name/password combination"
			render 'new'
		end
	end

	def destroy
		logger.debug "inside Sessions DESTROY"
		sign_out
		redirect_to root_url
	end
end
