class UsersController < ApplicationController
  before_filter :authenticate_user!

  before_filter only: [:albums] do |c|
    c.validate_friendship(User.find(params[:id])) 
  end

  def show
    @user = User.find(params[:id])

    if current_user.id != @user.id
      @friendship = Friendship.find_by_users(current_user.id, @user.id)
      @friendship = Friendship.new if @friendship.nil?
    end

    @post = Post.new
  end

  def edit
    @user = User.find(params[:id])

    if @user.id != current_user.id
      flash[:alert] = "No tiene permisos para continuar"
      redirect_to root_url
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = "Usuario modificado!"
      redirect_to @user
    else
      flash[:alert] = "La imagen debe ser jpg y debe pesar menos de 500kb"
      render "edit"
    end
  end

  def albums
    @user = User.find(params[:id])
    @albums = @user.albums
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
        @users << u if !@users.include?(u)
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
