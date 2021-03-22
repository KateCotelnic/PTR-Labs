defmodule Worker do
  use GenServer

  def init(tweetContent) do
    {:ok,%{name: tweetContent}}
  end

  def start_link(tweetContent) do
    GenServer.start_link(__MODULE__, tweetContent, name: __MODULE__)
  end

  def handle_call(:get, _from, state) do
#    {:ok, reply, new_state}
#    | {:ok, reply, new_state, :hibernate}
#    | {:remove_handler, reply}
    {:reply, {:ok, state}, state}
  end

  def handle_cast({:worker, tweetContent}, _smth) do
    print_tweet(tweetContent)
#    | {:noreply, new_state, timeout() | :hibernate | {:continue, term()}}
    {:noreply, %{}}
#    {:noreply, new_state}
  end

  def decode_tweet(tweetContent) do
    chars = [",", ".", "?", ":", "!"]
    decode = Poison.decode!(tweetContent.data)
    decode["message"]["tweet"]["text"]
    |> String.replace(chars, "")
    |> String.split(" ", trim: true)
  end

  def compare_emotions(emval) do
    # series of operations resembling a pipe with |> operator
    # Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end)
    # Enum.reduce is used as a building block. fn in the module is implemented on top of reduce
    emval
    |> Enum.reduce(0, fn values, acc -> EmotionVal.get_emotions(values) + acc end)
    |> Kernel./(length(emval))
  end

  def print_tweet(tweetContent) do
    #call the decode fn
    decodedTweet = decode_tweet(tweetContent)
    #call the compare fn
    comparedEmotions = compare_emotions(decodedTweet)

    if tweetContent.data =~ "panic" do
      IO.inspect("__________________Panic message detected________________")
      else
      IO.inspect(comparedEmotions)
      #IO.inspect("___________________________________________________________________________________________________________")
    end
  end

end