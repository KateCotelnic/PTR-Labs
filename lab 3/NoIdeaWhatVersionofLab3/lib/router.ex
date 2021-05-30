defmodule Router do
  use GenServer

  def start_link(message) do
    GenServer.start_link(__MODULE__, message, name: __MODULE__)
  end

  @impl true
  def init(message) do
    {:ok, message}
  end

  @impl true
  def handle_cast({:router, message}, state) do
    SentimentScore.Supervisor.addWorker(message)
    GenServer.cast(SentimentScore.Worker, {:worker, message})
    Tweet.Supervisor.addWorker(message)
    GenServer.cast(Tweet.Worker, {:worker, message})
    Users.Supervisor.addWorker(message)
    GenServer.cast(Users.Worker, {:worker, message})
    EngagementRatio.Supervisor.addWorker(message)
    GenServer.cast(EngagementRatio.Worker, {:worker, message})
    {:noreply, state}
  end
end