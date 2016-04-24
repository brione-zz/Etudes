defmodule Geom do
  @moduledoc """
  The Geom module knows about geometry.

  It could be useful. It isn't.
  """

  @doc """
  Computes the area of the geometric entity specified as the first parameter.

  Returns the computed area. 
  """
  def area(tuple) do
    case tuple do
      {:rectangle, width, height } when width >= 0 and height >= 0 ->
        width * height
      {:triangle, base, height} when base >= 0 and height >= 0 ->
        (base * height)/2.0
      {:circle, radius} when radius >= 0 ->
        :math.pi * radius * radius
      {:ellipse, a, b} when a >= 0 and b >= 0 ->
        :math.pi * a * b
    end
  end
end
