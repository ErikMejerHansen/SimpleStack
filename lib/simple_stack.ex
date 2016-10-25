defmodule SimpleStack do
  require Logger

  def start_link() do
    pid = spawn_link(fn () -> Logger.debug "Started" end)
    {:ok, pid}
  end

  def push(item) do end

  def pop() do end
end
