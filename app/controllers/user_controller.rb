class UserController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :"/users/signup"
    else
      redirect '/blogs'
    end
  end

  post '/signup' do
    if !User.all.find_by(username: params[:username], email: params[:email])
      if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
        user = User.new(username: params[:username], password: params[:password], email: params[:email])
        if user.save
          session[:user_id] = user.id
          user.save
          redirect "/#{user.slug}"
        else
          erb :"/users/signup", locals: {message: "<p style='color: red'>Please try another username or email</p>"}
        end
      else
        erb :"/users/signup", locals: {message: "<p style='color: red'>Please fill out all the fields.</p>"}
      end
    else
      erb :"/users/signup", locals: {message: "<p style='color: red'>Please use a different username or email.</p>"}
    end
  end

  get '/login' do
    if logged_in?
      redirect "/#{current_user.slug}/blogs"
    else
      erb :"/users/login"
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/#{user.slug}/blogs"
    else
      erb :"/users/login", locals: {message: "Failure to log in"}
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :"users/profile"
    else
      redirect '/'
    end
  end

  post '/:slug' do
    if !params[:title].empty? && !params[:content].empty?
      blog = Blog.create(title: params[:title], content: params[:content])
      current_user.blogs << blog
      blog.user_id = current_user.id
      redirect "/#{current_user.slug}"
    else
      erb :"users/profile", locals: {message: "<p style='color: red'>Please enter a title and content.</p>"}
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