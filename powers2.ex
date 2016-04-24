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

  def nth_root(x, n) do
    root = nth_root(x, n, x/2.0)
    IO.puts("Answer is #{ root }")
  end

  def nth_root(x, n, a) do
    IO.puts("current guess is #{ a }")
    f = raise(a, n) - x
    f_prime = n * raise(a, n - 1)
    next = a - f / f_prime
    change = abs(next - a)
    cond do
      change < 1.0e-8 ->
        next
      true ->
        nth_root(x, n, next)
    end
  end
end
