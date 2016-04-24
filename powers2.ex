defmodule(Powers2) do
  import Kernel, except: [raise: 2, raise: 3]
  def raise(_x, 0) do
    1
  end
  def raise(x, n) when n < 0 do
    1.0 / raise(x, -n)
  end
  def raise(x, n) do
    raise(x, n, 1)
  end
  def raise(_x, 0, acc) do
    acc
  end
  def raise(x, n, acc) do
    x * raise(x, n - 1, acc)
  end 

end
