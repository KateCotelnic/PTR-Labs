defmodule Collector do
    use GenServer

    def start_link() do
      GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    end

    def init(_arg) do
      map = %{}
      {:ok, map}
    end

    def handle_cast({:data, string}, map) do
      id = Enum.at(String.split(string, " ", parts: 2),0)
      data = Enum.at(String.split(string, " ", parts: 2),1)
      map = Map.update(map, id," " <> data, fn existing_value -> existing_value <> " " <> data end)
      str = Map.get(map, id)
      if String.contains?(to_string(str)," u ")
      && String.contains?(to_string(str)," s ")
      && String.contains?(to_string(str)," t ")
      && String.contains?(to_string(str)," r ") do
      insert_to_database(str)
      map = Map.delete(map, id)
      end
      {:noreply, map}
    end

    def insert_to_database(str) do
      split_array = String.split(str, "*^*")
      to_send = %{}
el1 = Enum.at(split_array,0)
el2 = Enum.at(split_array,1)
el3 = Enum.at(split_array,2)
el4 = Enum.at(split_array,3)

value = String.slice(el1, 3, 1000)
type = String.slice(el1, 1, 1)
type =  if type == "r" do
  "engagement ratio"
else type
  end
      type =  if type == "t" do
        "tweet text"
        else type
      end
      type =  if type == "u" do
        "username"
      else type
      end
      type =  if type == "s" do
        "sentiment score"
      else type
      end
to_send = Map.put(to_send, type, value)

      value = String.slice(el2, 3, 1000)
      type = String.slice(el2, 1, 1)
      type =  if type == "r" do
        "engagement ratio"
      else type
      end
      type =  if type == "t" do
        "tweet text"
      else type
      end
      type =  if type == "u" do
        "username"
      else type
      end
      type =  if type == "s" do
        "sentiment score"
      else type
      end
      to_send = Map.put(to_send, type, value)

      value = String.slice(el3, 3, 1000)
      type = String.slice(el3, 1, 1)
      type =  if type == "r" do
        "engagement ratio"
      else type
      end
      type =  if type == "t" do
        "tweet text"
      else type
      end
      type =  if type == "u" do
        "username"
      else type
      end
      type =  if type == "s" do
        "sentiment score"
      else type
      end
      to_send = Map.put(to_send, type, value)

      value = String.slice(el4, 3, 1000)
      type = String.slice(el4, 1, 1)
      type =  if type == "r" do
        "engagement ratio"
      else type
      end
      type =  if type == "t" do
        "tweet text"
      else type
      end
      type =  if type == "u" do
        "username"
      else type
      end
      type =  if type == "s" do
        "sentiment score"
      else type
      end
      to_send = Map.put(to_send, type, value)
      IO.inspect(to_send)
      GenServer.cast(DBConnect, {:data, to_send})
end
end
