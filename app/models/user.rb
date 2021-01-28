class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverted_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'

  has_many :f_posts, through: :friends, source: :posts

  def friends
    friend = Friendship.select("(CASE WHEN user_id = #{self[:id]} THEN friend_id ELSE user_id END) AS user_id, status")
    friend.where(['(user_id = ? OR friend_id = ?)', self[:id], self[:id]])
  end

  def invitable(user)
    fr = Friendship.all
    if id == user.id ||
       fr.any? { |f| (f.user_id == id && f.friend_id == user.id) || (f.user_id == user.id && f.friend_id == id) }
      return false
    end

    true
  end

  def requests
    Friendship.where(['friend_id = ? AND status IS null', self[:id]])
  end

  def friend?(user_id)
    friend = Friendship.select(:status).where("friend_id = #{user_id} AND user_id = #{self[:id]}")

    return false if friend.empty?

    friend.first.status
  end
end
