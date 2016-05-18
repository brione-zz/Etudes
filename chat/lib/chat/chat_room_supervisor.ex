defmodule ChatRoomSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do

    children = [
      worker(ChatRoom, []) # already has name of ChatRoom
    ]

    supervise(children, strategy: :one_for_one)
  end

end
