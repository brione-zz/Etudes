defmodule ChatRoomTest do
  use ExUnit.Case

  setup do
    {:ok, chatroom} = ChatRoom.start_link
    on_exit fn ->
      GenServer.stop(chatroom)
    end
    {:ok, %{chatroom: chatroom}}
  end

  test "login a user", %{chatroom: chatroom} do
    assert :ok = GenServer.call(chatroom, {:login, "brion", :server1})
    assert :error = GenServer.call(chatroom, {:login, "brion", :server1})
    assert :ok = GenServer.call(chatroom, {:login, "martin", :server1})
    assert :ok = GenServer.call(chatroom, {:login, "martin", :server2})
    assert :ok = GenServer.call(chatroom, {:login, "cardiff", :server2})
    assert :error = GenServer.call(chatroom, {:login, "cardiff", :server2})
  end

  test "logout a user", %{chatroom: chatroom} do
    GenServer.call(chatroom, {:login, "brion", :server1})
    assert :ok = GenServer.call(chatroom, :logout)
  end

  test "get user list", %{chatroom: chatroom} do
    GenServer.call(chatroom, {:login, "brion", :server1})
    assert [{"brion", :server1}] =  GenServer.call(chatroom, :users)
    GenServer.call(chatroom, {:login, "martin", :server1})
    assert [{"martin", :server1}, {"brion", :server1}] = 
        GenServer.call(chatroom, :users)
    GenServer.call(chatroom, {:login, "martin", :server2})
    GenServer.call(chatroom, {:login, "cardiff", :server2})
    assert 4 = length(GenServer.call(chatroom, :users))
  end

  test "say something", %{chatroom: chatroom} do
    GenServer.call(chatroom, {:login, "brion", :server1})
    assert :ok = GenServer.call(chatroom, {:say, "hello world"})
  end
end
