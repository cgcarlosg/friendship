class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friend_requests, foreign_key: :requester_id
  has_many :friend_offers, class_name: 'FriendRequest', foreign_key: :requestee_id

  has_many :friendships_made, -> { where accepted: true }, class_name: 'FriendRequest',
                                                           foreign_key: :requester_id
  has_many :friendships_approved, -> { where accepted: true }, class_name: 'FriendRequest',
                                                               foreign_key: :requestee_id
  has_many :friends_made, through: :friendships_made, source: :requestee
  has_many :friends_approved, through: :friendships_approved, source: :requester

  def friends
    User.where('id IN (?)', friend_ids)
  end

  def strangers
    ids = FriendRequest.other_user_id(id)
    User.where('id NOT IN (?) AND id != (?)', ids, id)
  end

  private

  def friend_ids
    FriendRequest.accepted.other_user_id(id)
  end
end
