defmodule Weather do
  use GenServer

  @moduledoc """
  Get the weather for a station from NOAA and parse it from XML, again :-)
  """

  ## Client API

  @doc """
  Start the client
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
  end

  ## Server API

  @doc """
  Initialize the server
  """
  def init(_args) do
    :inets.start
    {:ok, pid} = :inets.start(:httpc, [{:profile, :brione}])
  end

  @doc """
  The server is about to exit. Stop the inets application.
  """
  def terminate(_reason, _state) do
    :inets.stop
  end

  @doc """
  Handle calls to the server. Receive the station, fetch the data and present
  it.
  """
  def handle_call(station, _from, state) do
    url = 'http://w1.weather.gov/xml/current_obs/#{station}.xml'
    user_agent = {'User-Agent', 'Elixir'}
    {status, data} = :httpc.request(:get, {url, [user_agent]}, :brione)
    {:reply, {status, data},   state}
  end
end
