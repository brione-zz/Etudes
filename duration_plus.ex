defmodule DurationPlus do

  defmacro {m1,s1} + {m2,s2} do
    quote do
      secs = rem(unquote(s1) + unquote(s2), 60)
      mins = div(unquote(s1) + unquote(s2), 60)
      { unquote(m1) + unquote(m2) + mins, secs }
    end
  end

  defmacro term1 + term2 do
    quote do
      unquote(term1) + unquote(term2)
    end
  end

end
