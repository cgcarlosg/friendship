class Friendship < ApplicationRecord
  after_save :create_friendship
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def create_friendship
    return if Friendship.where(user_id: friend_id, friend_id: user_id)!= []
    user_friendship1 = Friendship.create(user_id: friend_id, friend_id: user_id)
    user_friendship1.save
  end

end
