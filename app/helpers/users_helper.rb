module UsersHelper
    def friendship(user)
      not_current_user(user)
    end
  
    def friend_list(user)
      link_to user.name, user_path(user.id)
    end
  
    private
  
    def index_friendship(user)
      if user.pending_friends.include?(current_user)
        render partial: 'accept_form', locals: { friendreq: user.friendships.where(friend_id: current_user.id).ids.split('/').join(',') }
      elsif user.friends.include?(current_user)
        label_tag 'Friends'
      else
        button_to 'Add Friend', friendships_path(friend_id: user.id)
      end
    end
  
    def show_friend(user)
      if current_user.pending_friends.include?(user)
        label_tag 'Pending'
      elsif user.friend_requests.include?(current_user)
        render partial: 'accept_form', locals: { friendreq: user.invitations.where(friend_id: current_user.id).ids.split('/').join(',') }
      elsif !user.friends.include?(current_user)
        button_to 'Add Friend', invitations_path(user_id: current_user.id, friend_id: user.id)
      else
        label_tag 'Friends'
      end
    end
  
    def not_current_user(user)
      invitations = current_user.invitations
      show_friend(user) if current_page?(user_path(user.id))
  
      if invitations.empty? || invitations.find_by(friend_id: user.id).nil?
        index_invitation(user)
      elsif invitations.find_by(friend_id: user.id).status == false
        label_tag 'Pending'
      else
        label_tag 'Friends'
      end
    end
  end
  