defmodule Publisher do
  use GenServer, restast: :permanent

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    send(socket)
  end

  def init(arg) do
    {:ok, arg}
  end


  def send(socket) do
    data = MongoConnect.getUser()
    sendData(socket, data, "users")
    data = MongoConnect.get()
    sendData(socket, data, "tweets")
    send(socket)
    {:noreply, socket}
    end

  def sendData(socket, data, type) when data != nil do
    map = %{"data": data, "topic": type}
    message = Poison.encode!(map)
    case :gen_tcp.send(socket, message) do
      :ok -> MongoConnect.delete(type,data["id"])
    end
  end

end
