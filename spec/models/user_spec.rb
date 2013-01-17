# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  before do 
  	@user = User.new(name: "Example", email: "example@gmail.com",
  		               password: "foobar", password_confirmation: "foobar")
  end

  subject {@user}

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  describe "when name is not presence" do
  	before { @user.name = "  " }
  	it { should_not be_valid }
  end

  describe "when password is not blank" do
  	before { @user.password = @user.password_confirmation = "" }
  	it { should_not be_valid }
  end

  describe "when password not mismatch password_confirmation" do
  	before { @user.password_confirmation = "abc" }
  	it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
  	before { @user.password_confirmation = nil }
  	it { should_not be_valid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by_email(@user.email) }

  	describe "with valid password" do
  		it { should == found_user.authenticate(@user.password) }
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_password) { User.find_by_email("invalid") }
  		it { should_not == user_for_invalid_password }
  		specify { user_for_invalid_password.should be_false }
  	end
  end
end
