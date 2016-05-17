defmodule Integration do
  use ExUnit.Case

  setup_all do
    {:ok, room} = ChatRoom.start_link
    on_exit fn -> GenServer.stop(room) end
    {:ok, %{room: room}}
  end

  setup do
    {:ok, client} = Person.start_link(node)
    {:ok, %{node: node, client: client}}
  end

  test "truth" do
    assert true
  end

  test "preconditions", context do
    assert context[:node]
    assert context[:room]
    assert context[:client]  
  end

end
