module FriendshipsHelper
  def list_friends
    arr = ''
    unless @users == nil
    @friends.each do |f|
      puts f
        arr << "<li>#{f.user.name} #{f.confirmed ? '': ', pending'}<li>"
    end
    arr.html_safe
  end
end
end
