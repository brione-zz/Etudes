defmodule(AskArea) do

  def area() do
    shape_char = String.first(IO.gets("R\)ectangle, T\)riangle, E\)llipse: "))
    shape_atom = char_to_shape(shape_char)
    { d1, d2 } = case shape_atom do
      :triangle -> get_dimensions("base", "height")
      :ellipse -> get_dimensions("major radius", "minor radius")
      :rectangle -> get_dimensions("width", "height")
      _ -> { shape_char, 0 }
    end
    calculate(shape_atom, d1, d2)
  end

  def char_to_shape(shape_char) do
    case String.upcase(shape_char) do
      "T" -> :triangle
      "E" -> :ellipse
      "R" -> :rectangle
      _ -> :unknown
    end
  end

  def get_number(prompt) do
    input = String.strip(IO.gets("Enter #{ prompt } > "), ?\n)
    :erlang.binary_to_integer(input)
  end

  def get_dimensions(p1, p2) do
    { get_number(p1), get_number(p2) }
  end

  def calculate(shape, d1, d2) do
    case shape do
      :unknown -> IO.puts("Unknown shape: #{ d1 }")
      _ ->
        cond do
          d1 < 0 or d2 < 0 ->
            IO.puts("Dimensions must be greater than zero")
          true ->
            Geom.area({ shape, d1, d2 })
        end        
    end
  end

end
