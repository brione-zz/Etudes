defmodule Integration do
  use ExUnit.Case, async: false

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
    client = context.client
    assert :ok == Person.login(client, "brion")
    users = Person.users(client)
    assert !Enum.empty?(users)
    assert Enum.find(users, fn(u) -> u == {"brion", context.node} end)
    assert :ok == Person.logout(client)
  end

end
