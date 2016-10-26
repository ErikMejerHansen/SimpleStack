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
    # Send the pop message with the PID of the current process.
    send(:stack, {:pop, self()})

    # And wait for the response
    receive do
      {:ok, element} ->
        element
      _ ->
        Logger.warn("Unexpected messaged received")
        :error
    end
  end


  def receiver(state) do
    state = receive do
      {:push, element} ->
        [element | state]
      {:pop, caller} ->

        [element | tail] = state
        send(caller, {:ok, element})

        tail
      _ ->
        Logger.warn("Unexpected messaged received")
        state
    end
    receiver(state)
  end

end
