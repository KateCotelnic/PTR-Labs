defmodule BrokerConnect do
  use GenServer

  def start_link(port) do
    {:ok, socket} = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def init(arg) do
    {:ok, arg}
  end

  def handle_cast({:data, data}, arg) do
    :gen_tcp.send(arg.socket , data)
    {:noreply, arg}
  end
end
