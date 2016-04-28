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

  def mean(list) do
    List.foldl(list, 0, &(&1 + &2))/length(list)
  end

  def stdv(list) do
    n = length(list)
    {sum, sum_of_squares} = List.foldl(list, {0, 0}, 
        fn(x, {s, ss}) -> { x + s, x * x + ss } end)
    :math.sqrt((n * sum_of_squares - sum * sum)/(n * (n - 1)))
  end

end
