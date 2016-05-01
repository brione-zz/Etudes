defmodule(Stats) do

  def minimum(list) do
    try do
      [h | t] = list
      minimum(t, h)
    rescue
      e -> e
    end
  end

  def maximum(list) do
    try do
      [h | t] = list
      maximum(t, h)
    rescue
      e -> e
    end
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
    try do
      List.foldl(list, 0, &(&1 + &2))/length(list)
    rescue
      e -> e
    end
  end

  def stdv(list) do
    try do
      n = length(list)
      {sum, sum_of_squares} = List.foldl(list, {0, 0}, 
          fn(x, {s, ss}) -> { x + s, x * x + ss } end)
      :math.sqrt((n * sum_of_squares - sum * sum)/(n * (n - 1)))
    rescue
      e -> e
    end
  end

end
