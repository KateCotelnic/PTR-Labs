defmodule Users.Worker do
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
    send(tweetContent)
    {:noreply, %{}}
  end

  def send(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    user = decode["message"]["tweet"]["user"]
    username = user["screen_name"]
    decodedId = decode["message"]["tweet"]["id"]
    toSend = to_string(decodedId) <> " u " <> to_string(username) <> "*^*"
    GenServer.cast(Collector,{:data, toSend})
    GenServer.cast(DBConnect, {:data, user})
  end
end