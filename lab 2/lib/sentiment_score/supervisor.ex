defmodule SentimentScore.Supervisor do
  use DynamicSupervisor

  # Automatically defines child_spec/1
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  # This will start child by calling MyWorker.start_link(init_arg, foo, bar, baz)
  def addWorker(message) do
    child_spec = {SentimentScore.Worker, {message}}

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def killWorker(worker_pid) do
    DynamicSupervisor.terminate_child(__MODULE__, worker_pid)
  end

  def cast_message(message) do
    GenServer.cast(SentimentScore.Worker, {:worker, message})
  end

end