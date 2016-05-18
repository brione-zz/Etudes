defmodule PersonTest do
  use ExUnit.Case, async: true

  setup do
    this_node = :localhost
    {:ok, _client} = Person.start_link(this_node)
    {:ok, %{node: this_node}}
  end

  test "test the client node function", context do
    assert context.node == Person.get_chat_node()
  end

  test "get empty user profile" do
    assert %{} == Person.get_profile
  end

  test "test user profile" do
    Person.set_profile(:name, "joe")
    Person.set_profile(:occupation, "plumber")
    assert %{name: "joe", occupation: "plumber"} == Person.get_profile
    Person.set_profile(:name, "frodo")
    assert %{name: "frodo", occupation: "plumber"} == Person.get_profile
  end

end
