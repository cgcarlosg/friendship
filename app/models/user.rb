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



  def send_invitation(user)
    friends.create(friend_id: user.id)
  end

end