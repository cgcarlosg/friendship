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

  has_many :requests_sent, -> { where(confirmed: false) }, class_name: 'Friendship'
  has_many :friend_requests, through: :requests_sent, source: :friend

  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def friends
    friends_array = friendships.map { |f| f.friend if f.confirmed }
    friends_array += inverse_friendships.map { |f| f.user if f.confirmed }
    friends_array.compact
  end

  def users_you_invited
    users = []
    friendships.select do |f|
      next unless f.confirmed.nil? && inverse_friendships.none? do |f2|
        f.friend_id == f2.user_id && f.user_id == f2.friend_id && f.id > f2.id
      end

      users.push(f.friend)
    end
    users
  end

  def users_who_invite_you
    users = []
    friendships.each do |f|
      next unless f.confirmed.nil? && inverse_friendships.none? do |f2|
        f.friend_id == f2.user_id && f.user_id == f2.friend_id && f.id < f2.id
      end

      users.push(f.friend)
    end
    users
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

  def posts_mine_or_friends
    Post.all.ordered_by_most_recent.select { |p| p if p.user_id == id || friends.any? { |f| f.id == p.user_id } }
  end
end
