defmodule(Geography) do

  def make_geo_list(name) do
    {:ok, res} = File.open(name, [:read, :utf8])
    list = make_geo_list(res, [])
    File.close(res)
    list
  end

  def make_geo_list(res, result) do
    case line = IO.read(res, :line) do
      :eof -> result
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

end
