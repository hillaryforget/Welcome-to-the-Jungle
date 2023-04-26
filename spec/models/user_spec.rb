require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should create a user if you enter an email, name, password and matching password confirmation' do
      @user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @user.valid?
      expect(@user.errors.full_messages.size).to eq(0)
    end

    it 'should throw an error when password and password confirmation do not match' do
      @user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: '1234')
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'should throw an error if you enter an email that already exists, even if different case' do
      @user1 = User.create(email: 'test@test.COM', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @user2 = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @user2.valid?
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end

    it 'should throw an error if you enter a password that is <10 characters' do
      @user = User.create(password: 'test123')
      @user.valid?
      expect(@user.errors[:password]).to include("is too short (minimum is 10 characters)")
    end

    it 'should trim extra spaces from before or after the email' do
      @user = User.create(email: '    test@test.com   ')
      @user.valid?
      expect(@user[:email]).to eq('test@test.com')
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should not succeed when a user enters an incorrect password' do
      @new_user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @existing_user = User.find_by_email('test@test.com')
      expect(User.authenticate_with_credentials('test@test.com', 'test12345678')).to eq(nil)
    end

    it 'should succeed when a user enters correct credentials' do
      @new_user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @existing_user = User.find_by_email('test@test.com')
      expect(User.authenticate_with_credentials('test@test.com', 'test123456')).to eq(@existing_user)
    end

    it 'should still authenticate when a user enters a correct email in wrong case' do
      @new_user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @existing_user = User.find_by_email('test@test.com')
      expect(User.authenticate_with_credentials('test@TEST.com', 'test123456')).to eq(@existing_user)
    end

    it 'should still authenticate when a user enters spaces before or after the email' do
      @new_user = User.create(email: 'test@test.com', name: 'Hillary Forget', password: 'test123456', password_confirmation: 'test123456')
      @existing_user = User.find_by_email('test@test.com')
      expect(User.authenticate_with_credentials('   test@test.com    ', 'test123456')).to eq(@existing_user)
    end
  end

end
