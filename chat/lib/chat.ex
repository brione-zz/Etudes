defmodule Chat do
  use Application

  def start(_type, _args) do
    ChatRoomSupervisor.start_link
  end
end
