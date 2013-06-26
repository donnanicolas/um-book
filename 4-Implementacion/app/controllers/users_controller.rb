class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])

    if current_user.id != @user.id
      @friendship = Friendship.find_by_users(current_user.id, @user.id)
      @friendship = Friendship.new if @friendship.nil?

    end

    @post = Post.new
    
    @posts = Post.where(user_a_id: @user.id)

  end

   def send_friendship
    @friendship = Friendship.new(params[:friendship])
    @friendship.user_a_id = current_user.id

    if @friendship.save
      flash[:notice] = "Solicitud de amistad enviada!"
      redirect_to @friendship.user_b
    end
  end


 def accept_friendship
    @friendship = Friendship.find_by_users(params[:friendship][:user_a_id], current_user.id)

    if @friendship
      @friendship.are_friends = true
      @friendship.save
    end
    redirect_to @friendship.user_a
  end
end
