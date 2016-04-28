defmodule(Comps) do

  def filter(list, cond) do
    for person = { n, s, a } <- list, cond.(person), do: { n, s, a }
  end

  def men_over_40({_n, s, a}) do
    s == "M" and a > 40
  end

  def men_or_over_40({_n, s, a}) do
    s == "M" or a > 40
  end

end
