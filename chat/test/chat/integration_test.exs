defmodule Integration do
  use ExUnit.Case

  setup do
    {:ok, room} = ChatRoom.start_link
    {:ok, client} = Person.start_link(:localhost)
    {:ok, %{node: :localhost, room: room, client: client}}
  end

  test "truth" do
    assert true
  end

  test "preconditions", context do
    assert context[:node]
    assert context[:room]
    assert context[:client]  
  end

  test "login a user", context do
    assert :ok == Person.login("brion")

  end

end
