defmodule ReceiverToSend do
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
    {:ok, request} = :gen_tcp.recv(socket, 0)
    to_string(request)
    |> process_request()
  end

  defp process_request(request) do
  topics = GenServer.call(Storage, :get)
    cond do
    Enum.member?(topics, request) ->
      GenServer.cast(Sender, {:subscribe, request})
      false ->
      GenServer.cast(Sender, {:error, request})
    end
  end
end