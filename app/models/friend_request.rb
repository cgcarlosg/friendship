class FriendRequest < ApplicationRecord
  self.primary_key = :requester_id, :requestee_id
  belongs_to :requester, class_name: 'User'
  belongs_to :requestee, class_name: 'User'

  validates_uniqueness_of :requester_id, scope: :requestee_id

  scope :pending, -> { where(accepted: false) }
  scope :accepted, -> { where(accepted: true) }
  scope :other_user_id, lambda { |user_id|
                          select("CASE WHEN requestee_id = #{user_id} THEN requester_id WHEN requester_id = #{user_id}
                          THEN requestee_id END AS user_id")
                            .where("requestee_id = #{user_id} OR requester_id = #{user_id}")
                        }
end
