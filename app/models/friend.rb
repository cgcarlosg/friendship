class Friend < ApplicationRecord

    belongs_to :user
    has_many :users
    
  def self.reacted?(id1, id2)
   case1 = !Friend.where(user_id: id1, friend_id: id2).empty?
   case2 = !Friend.where(user_id: id2, friend_id: id1).empty?
   case1 || case2
  end

  def self.confirmed_record?(id1, id2)
    case1 = !Friend.where(user_id: id1, friend_id: id2, status: true).empty?
    case2 = !Friend.where(user_id: id2, friend_id: id1, status: true).empty?
    case1 || case2
  end

  def self.find_invitation(id1, id2)
    if Friend.where(user_id: id1, friend_id: id2, status: true).empty?
        Friend.where(user_id: id2, friend_id: id1, status: true)[0].id
    else
        Friend.where(user_id: id1, friend_id: id2, status: true)[0].id
    end
  end
end
