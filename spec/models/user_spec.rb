require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validation' do
    it 'should save user when all required fields are set correctly' do
      @user = User.new(name: 'Caitlin C.', email: 'lol@aol.com', password: "12345hello", password_confirmation: "12345hello")
      expect(@user).to be_valid
    end

    it 'should not save if password and password_confirmation do not match' do
      @user = User.new(name: 'Caitlin C.', email: 'lol@aol.com', password: "12345hello", password_confirmation: "6789hello")
      @user.save 
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'should provide an error message if password not set' do
      @user = User.new(name: 'Caitlin C.', email: 'lol@aol.com', password: nil, password_confirmation: nil)
      @user.save
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'should provide an error message if name not set' do
      @user = User.new(name: nil, email: 'lol@aol.com', password: "12345hello", password_confirmation: "12345hello")
      @user.save
      # expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Name can't be blank")
    end

    it 'should provide an error message if email not set' do
      @user = User.new(name: 'Caitlin C.', email: nil, password: "12345hello", password_confirmation: "12345hello")
      @user.save
      # expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end

    it 'should have a minimun password length' do
      @user = User.new(name: 'Caitlin C.', email: 'lol@aol.com', password: "We", password_confirmation: "We")
      @user.save
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 5 characters)')
    end

  end

end