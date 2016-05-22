defmodule Person do
  use GenServer

  ## Client side API

  @doc """
  Start a client-side GenServer
  """
  def start_link(server_node) do
    GenServer.start_link(__MODULE__, [server_node], [])
  end

  @doc """
  A convenience function to get the name of the chat host node by doing 
  GenServer.call(Person, :get_chat_node)
  """
  def get_chat_node(pid) do
    GenServer.call(pid, :get_chat_node)
  end

  @doc """
  Calls the Person server with a {:login, user_name} request. 
  If the user name is an atom, use atom_to_binary/1 to convert it 
  to a string.
  """
  def login(pid, user_name) do
    GenServer.call(pid, {:login, user_name})
  end

  @doc """
  Calls the Person server with a :logout request. As you saw in the 
  description of chatroom, the server uses the process ID to figure 
  out who should be logged out.
  """
  def logout(pid) do
    GenServer.call(pid, :logout)
  end

  @doc """
  Calls the Person server with a {:say, text} request.
  """
  def say(pid, text) do
    GenServer.call(pid, {:say, text})
  end

  @doc """
  Calls the chat server with a :users request.
  """
  def users(pid) do
    GenServer.call(pid, :users)
  end

  @doc """
  Calls the chat server with a {:who, user_name, user_node} request to see 
  the profile of the given person. (extra credit)
  """
  def who(pid, user_name, user_node) do
    GenServer.call(pid, {:profile, user_name, user_node})
  end

  @doc """
  A convenience method that calls the Person server with a 
  {:set_profile, key, value} request. (extra credit)
  """
  def set_profile(pid, key, value) do
    GenServer.cast(pid, {:set_profile, key, value})
  end

  @doc """
  A convenience method to get the local profile.
  """
  def get_profile(pid) do
    GenServer.call(pid, :get_profile)
  end

  ## Server side API

  @doc """
  Perform local initialization
  """
  def init([server_node]) do
    {:ok, %{server: {ChatRoom, server_node}, 
        node: Kernel.node, user_profile: Map.new}}
  end

  @doc """
  Returns the chat node name that’s stored in the server’s state. 
  (Almost all of the wrapper functions to be described in the following 
  section will need the chat node name.)
  """
  def handle_call(:get_chat_node, _from, state) do
    {:reply, state.node, state}
  end

  @doc """
  Forward this request to the chat room server along with the person’s 
  server node name.
  """
  def handle_call({:login, user_name}, _from, state) do
    {:reply, GenServer.call(state.server, {:login, user_name, state.node}),
        state}
  end

  @doc """
  Forward this request to the chat room server.
  """
  def handle_call(:logout, _from, state) do
    {:reply, GenServer.call(state.server, :logout), state}
  end

  @doc """
  Forward this request to the chat room server.
  """
  def handle_call({:say, text}, _from, state) do
    {:reply, GenServer.call(state.server, {:say, text}), state}
  end

  @doc """
  Returns the profile that’s stored in the server’s state (extra credit)
  """
  def handle_call(:get_profile, _from, state) do
    {:reply, state[:user_profile], state}
  end

  @doc """
  Refer the :users command to the chat server
  """
  def handle_call(:users, _from, state) do
    {:reply, GenServer.call(state.server, :users), state}
  end 

  @doc """
  Pass the general :profile message on to the server. If it is our user,
  we'll have to handle the local profile message too.
  """
  def handle_call({:profile, user, server}, _from, state) do
    {:reply, GenServer.call(state.server, {:profile, user, server}), state}
  end

  @doc """
  Handle the local profile message.
  """
  def handle_call(:profile, _from, state) do
    {:reply, state.user_profile, state}
  end

  @doc """
  If the profile already contains the key, replace it with the 
  given value. Otherwise, add the key and value to the profile. 
  """
  def handle_cast({:set_profile, key, value}, state) do
    if Map.has_key?(state[:user_profile], key) do
      {:noreply, %{state | :user_profile => 
          Map.update!(state[:user_profile], key, fn(_v) -> value end)}}
    else 
      {:noreply, %{state | :user_profile =>
          Map.put(state[:user_profile], key, value)}}
    end
  end

  @doc """
  Because the chat room server uses GenServer.cast/2 to send messages 
  to the people in the room, your handle_cast/3 function will receive 
  messages sent from other users in this form: 
  {:message, {from_user, from_server}, text}
  """
  def handle_cast({:message, {from_user, from_server}, text}, state) do
    IO.puts("Message #{inspect from_user}@#{inspect from_server}: #{text}")
    {:noreply, state}
  end
end
