defmodule Geom do
  @moduledoc """
  The Geom module knows about geometry.

  It could be useful. It isn't.
  """

  @doc """
  Computes the area of the geometric entity specified as the first parameter.

  Returns the computed area. 
  """
  def area({:rectangle, width, height}) when width >= 0 and height >= 0 do
    width * height
  end
  def area({:triangle, base, height}) when base >= 0 and height >= 0 do
    ( base * height ) / 2.0
  end
  def area({:circle, radius}) when radius >= 0 do
    :math.pi * radius * radius
  end
  def area({:ellipse, a, b}) when a >= 0 and b >= 0 do
    :math.pi * a * b
  end
end
