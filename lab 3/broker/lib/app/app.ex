defmodule App.App do

  use Application

  @impl true
  def start(_type, _args) do

     children = [
      %{
        id: Receiver,
        start: {Receiver, :accept, [4040]}
      },
      %{
        id: ReceiverToSend,
        start: {ReceiverToSend, :accept, [4041]}
      },
      %{
        id: Storage,
        start: {Storage, :start_link, []}
      },
      %{
        id: Sender,
        start: {Sender, :start_link, [4042]}
      }
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end