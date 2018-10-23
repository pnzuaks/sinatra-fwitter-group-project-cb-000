class TweetsController < ApplicationController
  get '/tweets' do
  ensure_user_is_authenticated

    @user = User.find(session[:user_id])
    @tweets = Tweet.all
    erb :"/tweets/tweets"
  end

  post '/tweets' do
    if params[:content] == ""
      redirect to '/tweets/new'
    end

    @user = User.find(session[:user_id])
    @tweet = Tweet.create(content: params[:content])
    @user.tweets << @tweet
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/new' do
    ensure_user_is_authenticated
    erb :"/tweets/new"
  end

  get '/tweets/:id/edit' do
    ensure_user_is_authenticated
    @tweet = Tweet.find(params[:id])
    erb :"/tweets/edit_tweet"
  end

  get '/tweets/:id' do
    ensure_user_is_authenticated
    @tweet = Tweet.find(params[:id])
    erb :"/tweets/show_tweet"
  end

  post '/tweets/:id' do
    @tweet = Tweet.find(params[:id])

    if params[:content] == ""
      redirect to "/tweets/#{@tweet.id}/edit"
    end

    @tweet.update(content: params[:content])
    @tweet.save

    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])

    if Helpers.current_user(session).id == @tweet.user_id
      @tweet.delete
      redirect to "/tweets"
    else
      redirect to '/login'
    end
  end


  def ensure_user_is_authenticated
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
  end



end
