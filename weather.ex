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
        result = :xmerl_sax_parser.stream(data, [{:event_fun, &Parser.parse_event/3}, {:event_state, {[],[]}}])
        {:reply, result, [station|state]}
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
end

defmodule WeatherSup do
  use Supervisor
  @moduledoc """
  A supervisor for the Weather GenServer. Lacks shutting down the Weather
  server, which is a problem.
  """

  @doc """
  Start the supervisor
  """
  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  @doc """
  Initialize the supervisor by starting its children
  """
  def init(:ok) do
    children = [
      worker(Weather, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

end

defmodule Parser do
  @moduledoc """
  Use the xmerl_sax_parser to parse the data from the xml.
  """

  @doc """
  This is the event callback function that we passed to the
  :xmerl_sax_parser.stream method.
  """
  def parse_event(event, _location, tuple = {state, result}) do
    case event do
      {:startElement, _uri, name, _qname, _atts} ->
        cond do
          name == 'location' or name == 'observation_time_rfc822' or
              name == 'weather' or name == 'temperature_string' ->
              {name, result}             
          true ->
            tuple
        end
      {:endElement, _uri, name, _qname} ->
        cond do
          name == 'location' or name == 'observation_time_rfc822' or
              name == 'weather' or name == 'temperature_string' ->
            {nil, result}
          true ->
            tuple
        end
      {:characters, char_list} ->
        cond do
          state == 'location' or state == 'observation_time_rfc822' or
              state == 'weather' or state == 'temperature_string' -> 
            {state, [{state, List.to_string(char_list)}|result]}
          true ->
            tuple
        end        
      _ ->
        tuple
    end
  end
end
