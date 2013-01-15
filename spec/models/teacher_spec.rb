require 'spec_helper'

describe Teacher do
	before { @teacher = Teacher.new(name: "jean", password: "pass", password_confirmation: "pass") }

	subject { @teacher }

	it { should respond_to(:name) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }

	#it { should be_valid }

	describe "when name is not present" do
		before { @teacher.name = " " }
		it { should_not be_valid }
	end

	describe "when name is too long" do
		before { @teacher.name = "a" * 51 }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			teacher_with_same_name = @teacher.dup
			teacher_with_same_name.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @teacher.password = @teacher.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @teacher.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password_confirmation is nil" do
		before { @teacher.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @teacher.save }
		let(:found_user_array) { Teacher.where('name = ?', @teacher.name) }
		let(:found_user) { found_user_array[0] }

		describe "with valid password" do
			it { should == found_user.authenticate(@teacher.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end
end