defmodule Application do

  use Application

  @impl true
  def start(_type, _args) do

    children = [
      %{
        id: Sender,
        start: {Sender, :start_link, [4041]}
      }
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
