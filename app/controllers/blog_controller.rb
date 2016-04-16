class BlogController < ApplicationController

  get '/:slug/blogs' do
    if logged_in?
      erb :"/blogs/blogs"
    else
      redirect '/'
    end
  end

  get '/:slug/blogs/:id' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      @blog = Blog.find(params[:id])
      erb :"/blogs/show_blog"
    else
      redirect '/'

    end
  end

  get '/:slug/blogs/:id/edit' do
    @user = User.find_by_slug(params[:slug])
    if logged_in? && @user == current_user
      @blog = Blog.find(params[:id])
      erb :"/blogs/edit_blog"
    else
      redirect '/'
    end
  end

  patch '/:slug/blogs/:id' do
    @user = User.find_by_slug(params[:slug])
    @blog = Blog.find(params[:id])
    if !params[:title].empty? && !params[:content].empty?
      @blog.title = params[:title]
      @blog.content = params[:content]
    elsif !params[:title].empty? && params[:content].empty?
      @blog.title = params[:title]
    elsif !params[:content].empty? && params[:title].empty?
      @blog.content = params[:content]
    end
    @blog.save
    redirect "/#{@user.slug}/blogs/#{@blog.id}"
  end

  delete '/:slug/blogs/:id/delete' do
    @user = User.find_by_slug(params[:slug])
    @blog = Blog.find(params[:id])
    if current_user == @user && logged_in?
      @blog.delete
      redirect "/#{@user.slug}"
    else
      redirect "/"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end