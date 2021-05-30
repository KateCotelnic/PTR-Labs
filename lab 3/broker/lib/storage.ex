defmodule Storage do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_arg) do
    map = %{"users" => [], "tweets" => []}
    {:ok, map}
  end

  def handle_call({:get, topic}, map) do
    value = List.first(Map.get(topic))
    {:reply, value, map}
    end

  def handle_cast({:delete, topic}, map) do
    list = Map.get(topic)
    list = List.delete(list,List.first(list))
    map = Map.get_and_update(map, topic, fn value -> {value,list} end)
    {:noreply, map}
  end

  def handle_call(:get, map) do
    value = Map.keys(map)
    {:reply, value, map}
  end

  def handle_cast({:data, data, topic}, map) do
      list = Map.get(topic)
      list = List.insert_at(list, 0, data)
      map = Map.get_and_update(map, topic, fn value -> {value,list} end)
      {:noreply, map}
  end

end
