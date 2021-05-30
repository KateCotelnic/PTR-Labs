defmodule MongoConnect do
  use GenServer

  def start_link() do
    {:ok, pid} = Mongo.start_link(url: "mongodb://localhost:27017/my_tweets")
    GenServer.start_link(__MODULE__, %{pid: pid}, name: __MODULE__)
  end


  def init(arg) do
    {:ok, arg}
  end

  def get() do
    GenServer.call(__MODULE__, {:get,0})
  end

  @impl true
  def handle_call({:get, id}, arg) do
    data = Mongo.find_one(arg.pid, "Tweets1", id)
    IO.inspect(data)
    {:reply, data, arg}
  end

  def getUser() do
    GenServer.call(__MODULE__, {:getuser,0})
  end

  @impl true
  def handle_call({:getuser, id}, arg) do
    data = Mongo.find_one(arg.pid, "Users1", id)
    IO.inspect(data)
    {:reply, data, arg}
  end

  def delete(topic, id) do
    GenServer.call(__MODULE__, {:delete, topic, id})
  end

  @impl true
  def handle_cast({:delete, topic, id}, arg) do
    topic = with <<first::utf8, rest::binary>> <- topic, do: String.upcase(<<first::utf8>>) <> rest <> "1"
    data = Mongo.find_one(arg.pid, topic, id)
    {:noreply, arg}
  end

end
