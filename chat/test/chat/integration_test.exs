defmodule Integration do
  use ExUnit.Case

  setup do
    {:ok, room} = ChatRoom.start_link
    {:ok, client} = Person.start_link(Kernel.node())
    {:ok, %{node: Kernel.node(), room: room, client: client}}
  end

  @tag :distributed
  test "preconditions", context do
    assert context[:node]
    assert context[:room]
    assert context[:client]  
  end

  @tag :distributed
  test "login a user", context do
    assert :ok == Person.login("brion")
    users = Person.users
    assert !Enum.empty?(users)
    IO.inspect users
    assert Enum.find(users, fn(u) -> u == {"brion", context.node} end)
    assert :ok == Person.logout
  end

end
