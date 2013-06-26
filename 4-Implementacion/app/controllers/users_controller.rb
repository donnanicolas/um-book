class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])

    if current_user.id != @user.id
      @friendship = Friendship.find_by_users(current_user.id, @user.id)
      @friendship = Friendship.new if @friendship.nil?
    end

    @posts = Post.where(user_a_id: @user.id)

    @post = Post.new
  end

  def search
    @query = params[:query]
    
    if @query.blank?
      flash[:alert] = "Por favor ingrese un nombre a buscar"
      redirect_to root_url
    end

    @users = []
    @query.split.each do |word|
      User.search(word).each do |u|
        @users << u
      end
    end

    @users
  end

  def solicitudes
    current_user.mark_solicitudes_as_read
    @friendship = Friendship.new
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

      flash[:notice] = "Solicitud aceptada!"
    end

    redirect_to @friendship.user_a
  end
end
