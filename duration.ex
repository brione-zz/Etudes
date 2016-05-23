defmodule Duration do

  defmacro add({m1,s1}, {m2,s2}) do
    m = m1 + m2
    s = s1 + s2
    if s > 59 do
      quote do
        { unquote(m + 1), unquote(s - 60) }
      end
    else
      quote do 
        { unquote(m), unquote(s) }
      end
    end    
  end

end
