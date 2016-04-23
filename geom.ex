defmodule Geom do
  @moduledoc """
  The Geom module knows about geometry.

  It could be useful. It isn't.
  """

  @doc """
  Computes the area of the geometric entity specified as the first parameter.

  Returns the computed area. 
  """
  def area(:rectangle, width, height) do
    width * height
  end
  def area(:triangle, base, height) do
    ( base * height ) / 2.0
  end
  def area(:ellipse, a, b) do
    :math.pi * a * b
  end
end
