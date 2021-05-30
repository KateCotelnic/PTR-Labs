defmodule App.App do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Publisher,
        start: {Publisher, :start_link, [4040]}
      },
      %{
        id: MongoConnect,
        start: {MongoConnect, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end