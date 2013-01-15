FactoryGirl.define do
	factory :schedule do
		teacher_id 1
		lecture_session_id 1
		frequency ["Monday"]
		start_time DateTime.parse("2000-01-01 07:00:00")
		time_interval 30

		factory :teacherB_schedule do
			teacher_id 2
		end

		factory :precede_time_schedule do
			frequency ["Monday,Wednesday"]
			start_time DateTime.parse("2000-01-01 06:30:00")
			time_interval 30
		end

		factory :new_class_schedule do
			lecture_session_id 2
			frequency ["Tuesday,Thursday"]
		end

		factory :default_for_overlap_schedule do
			frequency "Monday,Wednesday,Friday"
		end

		factory :overlap_time_schedule do
			frequency ["Monday,Wednesday,Friday"]
			start_time DateTime.parse("2000-01-01 06:45:00")
			time_interval 30
		end

		factory :invalid_blank_schedule do
			time_interval ""
		end

		factory :invalid_string_schedule do
			time_interval "hello"
		end

		factory :updated_schedule do
			frequency "Tuesday"
			start_time DateTime.parse("2000-01-01 08:00:00")
			time_interval 45
		end

		factory :default_for_update_schedule do
			frequency "Monday"	
		end

		factory :default_overlap_class_schedule do
			lecture_session_id 2
			frequency "Monday,Tuesday,Wednesday,Friday"
			start_time DateTime.parse("2000-01-01 06:30:00")
			time_interval 45
		end
	end

	factory :teacher do
		#name "jean"
    sequence(:name) { |n| "Person #{n}" }
		password "pass"
		password_confirmation "pass"
	end

	factory :lecture_session do
		#name "english"
		sequence(:name) { |n| "Class #{n}"}
	end
end