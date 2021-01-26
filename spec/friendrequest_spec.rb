require 'rails_helper'

RSpec.describe 'Users', type: :request do
  context '#Controller' do
    it 'Enable to create a new user' do
      get '/users/sign_up'
      assert_response :success
    end
  end

  it 'name must not be in blank' do
    user = User.new(name: '').save
    expect(user).to eql(false)
  end
end

RSpec.describe User, type: :model do
  describe 'validation' do
    user = User.new(email: 'one@gmail.com', name: 'one', password: '111111')
    it 'should have a user' do
      user.name = nil
      expect(User.new).to_not be_valid
    end

    it 'should have a valid user' do
      expect(User.new(name: 'two', email: 'two@gmail.com', password: '111111')).to be_valid
    end
  end
end
