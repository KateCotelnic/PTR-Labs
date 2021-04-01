defmodule GetterStream do

  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    getTweet()
  end

  def getTweet() do
    receive do
      tweetContent -> tweetBehaviour(tweetContent)
    end
    getTweet()
  end

  def tweetBehaviour(tweetContent) do
    GenServer.cast(Router, {:router, tweetContent})
    getTweet()
  end

  def child_spec(opts) do
    #returns options by opts
    #child specs are encapsulated in the __MODULE__
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      #the child process is always restarted after given the shutdown command
      restart: :permanent,
      shutdown: 250
    }
  end

end