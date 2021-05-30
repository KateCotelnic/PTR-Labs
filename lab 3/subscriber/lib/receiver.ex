defmodule Receiver do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket, port)
  end

  defp loop_acceptor(socket, port) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Receiver.TaskSupervisor, fn -> serve(client, port) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket, port)
  end

  defp serve(socket, port) do
    read(socket, port)
    serve(socket, port)
  end

  defp read(socket, port) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    process_data(data,port)
  end

  defp process_data(message, port) do
    map = Poison.decode!(message)
    data = map["data"]
    check = map["check"]
    sha = :crypto.hash_init(:sha256)
    sha = :crypto.hash_update(sha, data)
    sha_binary = :crypto.hash_final(sha)
    sha_hex = sha_binary |> Base.encode16 |> String.downcase
    if check == sha_hex do
      send_ack("ok",port)
      else
      send_ack("not",port)
    end
  end

  def send_ack(mes,port) do
    socket = :gen_tcp.connect('127.0.0.1', port, [:binary, active: false])
    :gen_tcp.send(socket, mes)
  end
end