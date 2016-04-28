defmodule(Calculus) do

  def derivative(func, xval) do
    delta = 1.0e-10
    (func.(xval + delta) - func.(xval))/delta
  end

end
