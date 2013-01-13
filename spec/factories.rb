FactoryGirl.define do
	factory :schedule do
		teacher_id 1
		lecture_session_id 1
		frequency ["Monday"]
		start_time DateTime.parse("2000-01-01 07:00:00")
		time_interval 30

		factory :updated_schedule do
			frequency ["Tuesday"] 
			start_time DateTime.parse("2000-01-01 18:00:00")
			time_interval 45
		end

		factory :invalid_schedule do
			time_interval ""
		end

		factory :default_for_overlap_schedule do
			frequency "Monday,Wednesday,Friday"
		end

		factory :overlap_schedule do
			frequency ["Monday,Wednesday,Friday"]
			start_time DateTime.parse("2000-01-01 06:45:00")
			time_interval 30
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