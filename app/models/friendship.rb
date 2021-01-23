class Friendship < ApplicationRecord
    self.primary_key = :user_id, :friend_id
    belongs_to :user, class_name: 'User'
    belongs_to :friend, class_name: 'User'
  
    validates_uniqueness_of :user_id, scope: :friend_id
  
    def confirm_friend
      update_attributes(status: true)
      Friendship.create(friend_id: user_id,
                        user_id: friend_id,
                        status: true)
    end
  end