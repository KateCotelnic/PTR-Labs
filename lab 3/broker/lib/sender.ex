defmodule Sender do
  use GenServer, restart: :permanent

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    {:ok, port}
  end

  def handle_cast({:subscibe, request}, port) do
    topics = GenServer.call(Storage, :get)
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    if String.equivalent?(topics[0], request) do
        message = to_string(port + 1)
        :gen_tcp.send(socket, message)
        sending(port+1, request)
    end
    if String.equivalent?(topics[1], request) do
           message = to_string(port + 3)
           :gen_tcp.send(socket, message)
           sending(port+3, request)
         end
    {:noreply, port}
  end

  def handle_cast({:error, request}, port) do
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    to_send = "error"
    message = Poison.encode!(to_send)
    :gen_tcp.send(socket, message)
    {:noreply, port}
  end

  def sending(port, topic) do
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    data = GenServer.call(Storage, {:get, topic})
    sha = :crypto.hash_init(:sha256)
    sha = :crypto.hash_update(sha, data)
    sha_binary = :crypto.hash_final(sha)
    sha_hex = sha_binary |> Base.encode16 |> String.downcase
    to_send = %{"data": data, "check": sha_hex}
    message = Poison.encode!(to_send)
    :gen_tcp.send(socket, message)
    port1 = port + 1
    receive_ack(port1, topic)
    send(port, topic)
  end

  def receive_ack(port, topic) do
    socket = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    client = :gen_tcp.accept(socket)
    pid = spawn_link(__MODULE__, :serve, [client, topic])
    :ok = :gen_tcp.controlling_process(client, pid)
  end

  def serve(socket, topic) do
    socket
    |> read(topic)
  end

  def read(socket, topic) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
    |> process_data(topic)
  end

  def process_data(message, topic) do
    cond do
      String.equivalent?(message, "ok") -> GenServer.cast(Storage, {:delete, topic})
    end

  end

end
