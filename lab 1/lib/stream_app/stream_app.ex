defmodule TweetRang.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # The Stack is a child started via Stack.start_link([:hello])
      %{
        id: Worker,
        start: {Worker, :start_link, [""]}
      },
      %{
        id: TweetDynamicSupervisor,
        start: {TweetDynamicSupervisor, :start_link, [""]}
      },
      %{
        id: Router,
        start: {Router, :start_link, [""]}
      },
      %{
        id: Connection1,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: Connection2,
        start: {Connection, :start_link, ["http://localhost:4000/tweets/2"]}
      },
    ]

    # one_for_one: if a child process terminates, only that process is restarted.
    opts = [strategy: :one_for_one, name: TweetRang.Supervisor]

    Supervisor.start_link(children, opts)
  end
end