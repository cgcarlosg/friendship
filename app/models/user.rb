class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friends
  has_many :pending_friends, -> { where status: false }, class_name: 'Friend', foreign_key: "friend_id"

def myfriends
  people_i_invite = Friend.where(user_id: id, status: true).pluck(:friend_id)
  people_invited_me = Friend.where(friend_id: id, status: true).pluck(:user_id)
  ids = people_i_invite + people_invited_me
end

def  friend_with?(user)
  Friend.confirmed_record?(id, user.id)
end

  def send_invitation(user)
    friends.create(friend_id: user.id)
  end

end