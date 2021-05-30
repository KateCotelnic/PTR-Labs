defmodule Counter do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_arg) do
#    time = 0
    times = []
#    count = 0
#    while()
#    :timer.sleep(1)
    {:ok, times}
  end

  def handle_cast({:data, string}, times) do
    times = [string | times]
    IO.inspect(List.to_string(times).length)
    {:noreply, times}
  end
end
