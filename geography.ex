defmodule(Geography) do

  def make_geo_list(name) do
    {:ok, res} = File.open(name, [:read, :utf8])
    list = make_geo_list(res, [])
    File.close(res)
    list
  end

  def make_geo_list(res, result) do
    case line = IO.read(res, :line) do
      :eof ->
        result
      _ ->
        splits = String.split(line, ",")
        case length(splits) do
          2 -> 
            [ name, language ] = splits
            make_geo_list(res, 
                [%Country{ name: String.strip(name), 
                    language: String.strip(language) } | result])
          4 ->
            [country | rest] = result
            [ name, pop, lat, long ] = splits
            newCountry = %{country | cities: 
                [ %City{ name: String.strip(name), 
                      population: String.strip(pop),
                      latitude: String.strip(lat), 
                      longitude: String.strip(long) } | country.cities]}
            make_geo_list(res, [newCountry | rest])
        end

    end
  end

  def total_population(countries, language) do
    case find_language(countries, language) do
      {:ok, country} ->
        sum_population(country.cities, 0)
      {:error, _ } ->
        IO.puts("Language #{language} not found")
    end
  end

  def find_language(countries, language) do
    case theCountry = Enum.find(countries, :not_found,
        fn(country) -> country.language == language end) do
      :not_found -> {:error, :not_found }
      _ -> {:ok, theCountry }
    end
  end

  def sum_population([], total) do
    total
  end

  def sum_population([city | rest], total) do
    # IO.inspect city
    { population, _ } = Integer.parse(city.population)
    sum_population(rest, total + population)
  end

end
