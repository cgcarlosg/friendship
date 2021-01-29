class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  has_many :f_posts, through: :friends, source: :posts

  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def friends
    friends_array = []
    friendships.each { |f| friends_array.push(f.friend) if f.confirmed }
    inverse_friendships.each { |f| friends_array.push(f.user) if f.confirmed }
    friends_array.compact
  end

  def users_you_invited
    friendships.map { |f| f.friend unless f.confirmed }.compact
  end

  def users_who_invite_you
    inverse_friendships.map { |f| f.user unless f.confirmed }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |f| f.user == user }
    friendship.confirmed = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end

  def invitable(user)
    fr = Friendship.all
    if id == user.id ||
       fr.any? { |f| (f.user_id == id && f.friend_id == user.id) || (f.user_id == user.id && f.friend_id == id) }
      return false
    end

    true
  end
end
