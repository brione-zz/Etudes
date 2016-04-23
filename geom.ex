defmodule Geom do
  @moduledoc """
  The Geom module knows about geometry.

  It could be useful. It isn't.
  """

  @doc """
  Computes the area of the rectangle whose width and height are specified.

  Both input parameters default to 1.

  Returns the computed area. 
  """
  def area(width \\ 1, height \\ 1) do
    width * height
  end
end
