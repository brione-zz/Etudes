defmodule(Geography) do

  def make_geo_list(name) do
    {:ok, res} = File.open(name, [:read, :utf8])
    make_geo_list(res, [])
    File.close(res)
  end

  def make_geo_list(res, result) do
    case line = File.read(res, :line) do
      :eof -> result
      _ ->
        splits = String.split(line, ",")
        case length(splits) do
          2 -> %Country{ name: splits[0], language: splits[1] }
          4 -> %City{ name: splits[0], population: splits[1],
                      latitude: splits[2], longitude: [3]}
        end

    end
  end

end
