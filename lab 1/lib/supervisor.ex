defmodule TweetDynamicSupervisor do
  use DynamicSupervisor

  # Automatically defines child_spec/1
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

#  @impl true
#  def init(:ok) do
#    connection_specs =
#      for index <- 1..10 do
#        DynamicSupervisor.child_spec({__MODULE__, {host, port}}, id: {__MODULE__, index})
#      end
#
#    connection_supervisor_spec = %{
#      id: :connection_supervisor,
#      type: :supervisor,
#      start: {DynamicSupervisor, :start_link, [connection_specs, [strategy: :one_for_one]]}
#    }
#
#    children = [
#      {Registry, name: FantaRegistry, keys: :duplicate},
#      connections_supervisor_spec
#    ]
#
#    DynamicSupervisor.init(children, strategy: :one_for_one)
#  end

  # This will start child by calling MyWorker.start_link(init_arg, foo, bar, baz)
  def addWorker(message) do
    child_spec = {Worker, {message}}

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def killWorker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def cast_message(message) do
    GenServer.cast(Worker, {:worker, message})
  end

end