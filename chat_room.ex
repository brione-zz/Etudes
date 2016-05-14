defmodule ChatRoom do
  use GenServer

  @doc """
  Start the chat room server, with initial state of an empty list of clients
  """
  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], [])
  end

  @doc """
  Initialize the server
  """
  def init(_args) do

  end

  @doc """
  Adds the user name, server name, and pid (which is in the from parameter)
  to the server’s state. Don’t allow a duplicate user name from the same 
  server. You can use List.keymember?/3 for this.
  """
  def handle_call({:login, user_name, server_name}, from, state) do


  end

  @doc """
  Removes the user from the state list.
  """
  def handle_call(:logout, from, state) do


  end

  @doc """
  Sends the given text to all the other users in the chat room. Use 
  GenServer.cast/2 to send the message to each user. You may use a 
  process id as the first argument to GenServer.cast/2.
  """
  def handle_call({:say, text}, from, state) do


  end

  @doc """
  Returns the list of names and servers for all people currently in 
  the chat room.
  """
  def handle_call(:users, from, state) do


  end

  @doc """
  Return the profile of the given person/server. (This is "extra credit"; 
  see the following details about the Person module). It works by finding
  the pid of person at node server_name and sending it a :get_profile
  request.
  """
  def handle_call({:profile, person, server_name}, from, state) do


  end

end


defmodule ChatClient do
  use GenServer


end
