defprotocol Valid do
  @doc "Returns true if city is valid"
  def valid?(city)
end

defmodule(City) do
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0
end

defimpl Valid, for: City do
  def valid?(%City{population: p, latitude: lat, longitude: long } ) do
    p > 0 && lat <= 90 && lat >= -90 && long >= -180 && long <= 180
  end
end
