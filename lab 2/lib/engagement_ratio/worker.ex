defmodule EngagementRatio.Worker do
  use GenServer

  def init(tweetContent) do
    {:ok,%{name: tweetContent}}
  end

  def start_link(tweetContent) do
    GenServer.start_link(__MODULE__, tweetContent, name: __MODULE__)
  end

  def handle_call(:get, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:worker, tweetContent}, _smth) do
    compute_ratio(tweetContent)
    {:noreply, %{}}
  end

  def decode_id(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["id"]
  end

  def decode_favorite(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["user"]["favourites_count"]
  end

  def decode_retweets(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["retweet_count"]
  end

  def decode_followers(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["user"]["followers_count"]
  end

  def compute_ratio(tweetContent) do
    favorites = decode_favorite(tweetContent)
    retweets = decode_retweets(tweetContent)
    followers = decode_followers(tweetContent)
    decodedId = decode_id(tweetContent)
    count = favorites + retweets
    ratio = count / followers
    toSend = to_string(decodedId) <> " r " <> to_string(ratio) <> "*^*"
    GenServer.cast(Collector,{:data, toSend})
  end
end