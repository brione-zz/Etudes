defmodule ChatRoom do
  use GenServer

  @doc """
  Start the chat room server, with initial state of an empty list of clients
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  @doc """
  Initialize the server
  """
  def init(user_list) do
    {:ok, user_list}    
  end

  @doc """
  Adds the user name, server name, and pid (which is in the from parameter)
  to the server’s state. Don’t allow a duplicate user name from the same 
  server. You can use List.keymember?/3 for this. The tuple looks like this:
  {{user, user_server}, pid}
  """
  def handle_call({:login, user_name, user_server}, 
      {pid, _refnum}, user_list) do
    if !List.keymember?(user_list, user = {user_name, user_server}, 0) do
      {:reply, :ok, [{user, pid}|user_list]}
    else
      :error_logger.info_msg(
        "Duplicate user/server combination: #{user_name}/#{user_server}\n")
      {:reply, :error, user_list}
    end
  end

  @doc """
  Removes the user from the state list.
  """
  def handle_call(:logout, {pid, _refnum}, user_list) do
    case List.keytake(user_list, pid, 1) do
      nil ->
        :error_logger.info_msg( 
            "No user with pid: #{pid} found\n")
        {:reply, :error, user_list}
      {{{user_name, user_server}, pid}, new_user_list} ->
        :error_logger.info_msg(
            "User #{user_name} logged out of chat room\n")
        {:reply, :ok, new_user_list}
    end
  end

  @doc """
  Sends the given text to all the other users in the chat room. Use 
  GenServer.cast/2 to send the message to each user. You may use a 
  process id as the first argument to GenServer.cast/2.
  """
  def handle_call({:say, text}, {pid, _refnum}, user_list) do
    sender = List.keyfind(user_list, pid, 1)
    Enum.each(user_list, fn({_user, pid}) -> 
        GenServer.cast(pid, {:message, sender, text}) end)
    {:reply, :ok, user_list}
  end

  @doc """
  Returns the list of names and servers for all people currently in 
  the chat room.
  """
  def handle_call(:users, from, user_list) do
    {:reply, Enum.map(user_list, fn({user, _pid}) -> user end), user_list}
  end

  @doc """
  Return the profile of the given person/server. (This is "extra credit"; 
  see the following details about the Person module). It works by finding
  the pid of person at node server_name and sending it a :get_profile
  request.
  """
  def handle_call({:profile, person, server}, {pid, _refnum}, user_list) do
    case List.keyfind(user_list, {person, server}, 0) do
      nil -> 
        :error_logger.info_msg("User #{person}@#{server} not found\n")
        {:reply, :error, user_list}
      {user, user_pid} ->
        {:reply, GenServer.call(user_pid, :profile), user_list}
    end
  end

end
