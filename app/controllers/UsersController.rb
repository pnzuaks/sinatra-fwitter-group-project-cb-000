class UsersController < ApplicationController
  get '/signup' do
    if Helpers.is_logged_in?(session)
      showAllTweets
    else
      erb :"/users/create_user"
    end
  end

  post '/signup' do
    SignUpNewUserCommand.new(params[:username], params[:password], params[:email], self).execute
  end

  get "/show" do
    ensure_user_is_authenticated
    @tweets = Tweet.all
    @user = User.find(session[:user_id])
    erb :"/users/show"
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      showAllTweets
    else
      erb :"/users/login"
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      showAllTweets
    else
      redirect to "/failure"
    end
  end

  get "/failure" do
    erb :"/users/failure"
  end

  get '/logout' do
    session.clear
    redirect "/login"
  end

  def showAllTweets
    redirect to '/tweets'
  end

  def ensure_user_is_authenticated
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
  end

  def showLoginView
    erb :"/users/login"
  end

  def signup_success
    redirect to '/tweets'
  end

  def signup_failure
    redirect to '/signup'
  end

end


class SignUpNewUserCommand
  def initialize(username, password, email,controller)
      @username = username
      @password = password
      @email = email
      @controller = controller
  end

  def execute
    if @username == "" || @password == "" || @email == ""
      return @controller.signup_failure
    end

    @user = User.create(username: @username, password: @password, email: @email)
    @user.save
    @controller.signup_success
  end

end
