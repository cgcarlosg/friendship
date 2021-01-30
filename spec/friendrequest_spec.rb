require 'rails_helper'

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

RSpec.describe 'Friendship', type: :model do
  it 'will check for create a valid friendship ' do
    f = User.create!(email: 'test1@gmail.com', name: 'moon', password: '123456')
    v = Friendship.new(user_id: f.id)
    expect(v).to_not be_valid
  end
end

RSpec.describe Friendship, type: :model do
  before(:each) do
    @a = User.create(name: 'a', email: 'a@a.com', password: '111111', password_confirmation: '111111')
    @a.save
    @b = User.create(name: 'b', email: 'b@b.com', password: '222222', password_confirmation: '222222')
    @b.save
  end
  
  context 'testing friendship model' do
    it 'create valid friendship' do
      f1 = Friendship.new(user_id: @a.id, friend_id: @b.id, confirmed: true)
      expect(f1.valid?).to eq(true)
    end

    it 'create valid friendship' do
      f1 = Friendship.new(user_id: @a.id, friend_id: @b.id, confirmed: true)
      f1.save
      expect(Friendship.all.length).to eq(2)
    end

    it 'create invalid friendship' do
      f1 = Friendship.new(user_id: 3, friend_id: 4, confirmed: true)
      expect(f1.valid?).to eq(false)
    end

    it 'destroy friendship' do
      f1 = Friendship.new(user_id: @a.id, friend_id: @b.id, confirmed: true)
      f1.save
      Friendship.destroy(f1.id)
      expect(Friendship.all.length).to eq(1)
    end
  end
end
