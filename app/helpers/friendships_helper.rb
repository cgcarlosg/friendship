module FriendshipsHelper
    def add_btn
        message = ''
        if current_user
            if @friend != false
                message << link_to( "Friendship revoke", friendship_path(current_user), method: :delete, class: "btn" )
            elsif @friend == nil
                message << 'Pending'
            else
                message << link_to( "Add", friendships_url(friend_id: params[:id]), method: :post, class: "btn" )
            end
        end
        message.html_safe
    end

    def list_friends
        message = ''
        @friends.each do |f|
            puts f
            message << "<li>#{f.user.name} #{f.status ? '': ', pending'}<li>"
        end
        message.html_safe
    end

    def list_requests 
        message = ''
        @requests.each do |f|
        message << " #{link_to("Accept", friendship_url(id: f.id), method: :patch, class: "btn")}
            #{link_to("Decline", friendship_url(id: f.id), method: :delete, class: "btn decline")}"
        end
        message.html_safe
    end

end