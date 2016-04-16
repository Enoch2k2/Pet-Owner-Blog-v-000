class PetController < ApplicationController

  get '/:slug/pets/new' do
    @user = User.find_by_slug(params[:slug])
    if current_user == @user && logged_in?
      erb :"/pets/new_pet"
    else
      redirect '/'
    end
  end

  post '/:slug/pets/new' do
    @user = User.find_by_slug(params[:slug])
    @pet = Pet.create(name: params[:name], age: params[:age], breed: params[:breed])
    @pet.user_id = @user.id
    @user.pets << @pet
    @pet.save
    @user.save
    redirect "/#{@user.slug}"
  end

  get '/:slug/pets/:id/edit' do
    @user = User.find_by_slug(params[:slug])
    @pet = Pet.find(params[:id])
    if current_user == @user && logged_in?
      erb :"/pets/edit_pet"
    else
      redirect "/"
    end
  end

  patch '/:slug/pets/:id/edit' do
    @user = User.find_by_slug(params[:slug])
    @pet = Pet.find(params[:id])
    if !params[:name].empty?
      @pet.name = params[:name]
    end
    if !params[:age].empty?
      @pet.age = params[:age]
    end
    if !params[:breed].empty?
      @pet.breed = params[:breed]
    end
    @pet.save
    redirect "/#{@user.slug}"
  end
  
  delete '/:slug/pets/:id/delete' do
    @user = User.find_by_slug(params[:slug])
    @pet = Pet.find(params[:id])
    if @user == current_user && logged_in?
      @pet.delete
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