defmodule SentimentScore.Worker do
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

  def decode_tweet(tweetContent) do
    chars = [",", ".", "?", ":", "!"]
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["text"]
          |> String.replace(chars, "")
          |> String.split(" ", trim: true)
  end

  def decode_id(tweetContent) do
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["id"]
  end

  def compare_emotions(emval) do
    # series of operations resembling a pipe with |> operator
    # Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)
    # Enum.reduce is used as a building block. fn in the module is implemented on top of reduce
    emval
    |> Enum.reduce(0, fn values, acc -> EmotionVal.get_emotions(values) + acc end)
    |> Kernel./(length(emval))
  end

  def send(tweetContent) do
    decodedTweet = decode_tweet(tweetContent)
    decodedId = decode_id(tweetContent)
    comparedEmotions = compare_emotions(decodedTweet)
    toSend = to_string(decodedId) <> " s " <> to_string(comparedEmotions) <> "*^*"
    GenServer.cast(Collector,{:data, toSend})
  end

end