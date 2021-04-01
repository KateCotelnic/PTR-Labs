defmodule DBConnect do
  use GenServer
  def start_link(string) do
    GenServer.start_link(__MODULE__, string, name: __MODULE__)
  end

  def init(_smth) do
    list = []
    {:ok, list}
  end
	
  defp insert_to_db(string, collection) do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017/my_tweets")
    Mongo.insert_one!(pid, collection, string)
  end

  @impl true
  def handle_cast({:data, item}, list) do
    add_to_db = [item | list]
    if Enum.count(add_to_db) >= 128 do
      GenServer.cast(__MODULE__, :batch)
    end

    {:noreply, add_to_db}
  end

  @impl true
  def handle_cast(:batch, list) do
    spawn(fn ->
      Enum.each(list, fn item ->
        if Map.equal?(Map.take(item, ["protected"]),%{"protected" => false}) do
      insert_to_db(item, "Users")
      else
           insert_to_db(item, "Tweets")
      end
      end)
    end)
    {:noreply, []}
  end
end