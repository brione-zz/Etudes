defmodule(Stats) do

  def minimum([h | t]) do
    minimum(t, h)
  end

  def maximum([h | t]) do
    maximum(t, h)
  end

  def range(list) do
    [ maximum(list), minimum(list)]
  end

  defp maximum([], max) do
    max
  end

  defp maximum([h | t], max) do
    cond do
      h > max -> maximum(t, h)
      true -> maximum(t, max)
    end
  end

  defp minimum([], min) do
    min
  end

  defp minimum([h | t], min) do
    cond do
      h < min -> minimum(t, h)
      true -> minimum(t, min)
    end
  end

end
