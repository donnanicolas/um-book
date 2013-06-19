class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @post = Post.new
    @posts = current_user.home_posts
  end

end
