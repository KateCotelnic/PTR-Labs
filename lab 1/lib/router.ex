defmodule Router do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message, name: __MODULE__)
  end

  @impl true
  def init(message) do
    {:ok, message}
  end

#  def call(pool) do
#    :poolboy.transaction(pool, fn(pid) -> GenServer.call(pid, :do_work) end)
#  end

#  {:ok, pool} = :poolboy.start_link([worker_module: Worker, size: 5, max_overflow: 0])

  @impl true
  def handle_cast({:router, message}, state) do


    my_workers = TweetDynamicSupervisor.addWorker(message)

    Enum.each(1..5, fn(_x) ->
      Registry.register(MyRegistry, my_workers, keys: :unique)
    end)

    connections = Registry.lookup(MyRegistry)
    next_index = RoundRobin.read_and_increment()

    {pid, _value = nil} = Enum.at(connections, rem(next_index, length(connections)))

    GenServer.cast(pid, {:worker, message})
    {:noreply, state}
  end

end