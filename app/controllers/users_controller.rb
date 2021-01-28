class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    
  end

  def show
    @user = User.find(params[:id])
    ids = Friendship.where(user_id: current_user, status: true).pluck(:friend_id)
    ids << current_user.id
    @friend = current_user.friend? params[:id]
    @posts = @user.posts.ordered_by_most_recent if ids.include?(@user.id)
    
  end
end
