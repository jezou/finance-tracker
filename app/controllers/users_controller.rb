class UsersController < ApplicationController

  def my_portfolio
    @stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @friends = current_user.friends
  end

  def search_friends
    @users = User.search(params[:search_param])
    logger.info("Test")
    if @users
      @users = current_user.except_current_user(@users)
      render partial: "friends/lookup"
    else
      render status: :not_found, nothing:true
    end
  end

  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)
    if current_user.save
      flash[:notice] = "Friend was successfully added"
      redirect_to my_friends_path
    else
      flash[:error] = "There was an error adding this user as a friend"
      redirect_to my_friends_path
    end
  end

  def show
    @user = User.find(params[:id])
    @stocks = @user.stocks
  end
end
