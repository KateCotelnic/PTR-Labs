defmodule TweetRang.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # The Stack is a child started via Stack.start_link([:hello])
      %{
        id: DBConnect,
        start: {DBConnect, :start_link, [""]}
      },
      %{
        id: Collector,
        start: {Collector, :start_link, []}
      },
      %{
        id: SentimentScore.Supervisor,
        start: {SentimentScore.Supervisor, :start_link, [""]}
      },
      %{
        id: Tweet.Supervisor,
        start: {Tweet.Supervisor, :start_link, [""]}
      },
      %{
        id: Users.Supervisor,
        start: {Users.Supervisor, :start_link, [""]}
      },
      %{
        id: EngagementRatio.Supervisor,
        start: {EngagementRatio.Supervisor, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: GetterStream1,
        start: {GetterStream, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: GetterSteam2,
        start: {GetterStream, :start_link, ["http://localhost:4000/tweets/2"]}
      },
    ]

    # one_for_one: if a child process terminates, only that process is restarted.
    opts = [strategy: :one_for_one,
            name: TweetRang.Supervisor,
            max_restarts: 5,
            max_seconds: 5,
           ]

    Supervisor.start_link(children, opts)
  end
end