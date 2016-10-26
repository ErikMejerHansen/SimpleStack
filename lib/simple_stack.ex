defmodule SimpleStack do
  require Logger


  def start_link() do
    pid = spawn_link(__MODULE__, :receiver, [[]])
    Process.register(pid, :stack)
    {:ok, pid}
  end

  def push(element) do
    send(:stack, {:push, element})

    :ok
  end

  def pop() do
    send(:stack, {:pop, self()})

    receive do
      {:ok, element} ->
        element
      _ ->
        Logger.warn("Unexpected messaged recieved")
        :error
    end
  end


  def receiver(state) do
    state = receive do
      {:push, element} ->
        [element | state]
      {:pop, caller} ->

        [element | state] = state
        send(caller, {:ok, element})

        state
      _ ->
        Logger.warn("Unexpected messaged recieved")
        state
    end
    receiver(state)
  end

end
