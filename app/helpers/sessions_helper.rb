module SessionsHelper
	def sign_in(teacher)
		cookies[:remember_token] = teacher.name
		self.current_teacher = teacher
	end

	def signed_in?
		!current_teacher.nil?
	end

	def current_teacher=(teacher)
		@current_teacher = teacher
	end

	def current_teacher
		@current_teacher ||= Teacher.login(cookies[:remember_token])
	end

	def current_teacher?(teacher)
		teacher == current_teacher
	end

	def sign_out
		self.current_teacher = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end
