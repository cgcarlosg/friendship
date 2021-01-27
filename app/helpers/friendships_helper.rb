module FriendshipsHelper
  def add_btn
    message = ''
    if current_user
      message << if @friend == false
                   link_to('Invite to Friendship', friendships_url(friend_id: params[:id]), method: :post,
                                                                                            class: 'btn btn-secondary')
                 elsif @friend.nil?
                   'Pending'
                 else
                   'friends'
                 end
    end
    message.html_safe
  end

  def list_friends
    message = ''
    @friends.each do |f|
      message << " #{f.user.name} ' / ' #{f.status ? 'Already friends' : ' pending'} <br/><br/>"
    end
    message.html_safe
  end

  def list_requests
    message = ''
    @requests.each do |f|
      message << " #{link_to('Accept', friendship_url(id: f.id), method: :patch, class: 'btn')}
            #{link_to('Decline', friendship_url(id: f.id), method: :delete, class: 'btn decline')}"
    end
    message.html_safe
  end
end
