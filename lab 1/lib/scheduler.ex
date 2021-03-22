defmodule RoundRobin do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    ets = :ets.new(__MODULE__, [:public, :named_table])
    :ets.insert(__MODULE__, {:index, -1})
    {:ok, ets}
  end

  def read_and_increment do
    :ets.update_counter(__MODULE__, _key = :index, _increment_by = 1)
  end
end