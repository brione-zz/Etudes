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

  @doc """
  Return the weather report for the station specified or an error tuple
  """
  def report(station) do
    GenServer.call(Weather, {:report, station})
  end

  @doc """
  Have the server print out a list of recent successful stations we've accessed
  """
  def recent do
    GenServer.cast(Weather, :recent)
  end

  ## Server API

  @doc """
  Initialize the server
  """
  def init(_args) do
    { :inets.start, [] }
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
  def handle_call({:report, station}, _from, state) do
    url = 'http://w1.weather.gov/xml/current_obs/#{station}.xml'
    user_agent = {'User-Agent', 'Elixir(brione2001@gmail.com)'}
    request = {url, [user_agent]}
    {:ok, {status,_headers,data}} = :httpc.request(:get, request, [], [])
    case status do
      {_, 200, _} -> 
        xml = List.to_string(data)
        {:reply, [get_content("location", xml), 
            get_content("weather", xml),
            get_content("observation_time_rfc822", xml), 
            get_content("temperature_string", xml)],  
            [station|state]}
      {_,code, _} -> {:reply, {:error, code}, state}
    end
  end

  @doc """
  Handle cast calls. This will result in printing the latest stations
  to the standard output.
  """
  def handle_cast(:recent, state) do
    IO.inspect(state)
    {:noreply, state}
  end

  @doc """
  This code came nearly straight from Elixir Etudes, but for some reason he
  call atom_to_string on the element name in the xml closing pattern and it
  both caused problems and is not needed.
  """
  def get_content(element_name, xml) do
    {_, pattern} = Regex.compile(
      "<#{element_name}>([^<]+)</#{element_name}>")
    result = Regex.run(pattern, xml)
    case result do
      [_all, match] -> {element_name, match}
      nil -> {element_name, nil}
    end
  end 
end

defmodule WeatherSup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Weather, [])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
