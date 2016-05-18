defmodule PersonTest do
  use ExUnit.Case, async: true

  setup do
    this_node = Kernel.node
    {:ok, client} = Person.start_link(this_node)
    {:ok, %{node: this_node, client: client}}
  end

  @tag :distributed
  test "test the client node function", context do
    assert context.node == Person.get_chat_node(context.client)
  end

  @tag :distributed
  test "get empty user profile", context do
    assert %{} == Person.get_profile(context.client)
  end

  @tag :distributed
  test "test user profile", context do
    client = context.client
    Person.set_profile(client, :name, "joe")
    Person.set_profile(client, :occupation, "plumber")
    assert %{name: "joe", occupation: "plumber"} == Person.get_profile(client)
    Person.set_profile(client, :name, "frodo")
    assert %{name: "frodo", occupation: "plumber"} == Person.get_profile(client)
  end

end
