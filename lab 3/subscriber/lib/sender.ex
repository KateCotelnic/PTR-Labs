defmodule Sender do
  use GenServer

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    send(socket)
  end

  def init(arg) do
    {:ok, arg}
  end


  def send(socket) do
    request = "users"
    :gen_tcp.send(socket, request)
    {:noreply, socket}
  end
end
