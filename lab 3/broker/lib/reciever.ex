defmodule Receiver do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Receiver.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read()
    serve(socket)
  end

  defp read(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
    |> process_data()
  end

  defp process_data(message) do
    map = Poison.decode!(message)
    data = map["data"]
    topic = to_string(map["topic"])
    GenServer.cast(Storage, {:data, data, topic})
  end
end