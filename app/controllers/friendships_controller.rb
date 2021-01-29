class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    f1 = Friendship.create(user_id: current_user.id, friend_id: params[:id])
    f1.save
    redirect_to request.referrer
  end

  def edit
    f1 = current_user.inverse_friendships.find_by_user_id(params[:id])
    if params[:answer] == '1'
      f1.confirmed = true
      f1.save
    elsif params[:answer] == '0'
      Friendship.destroy(f1.id)
    end
    redirect_to request.referrer
  end
end
