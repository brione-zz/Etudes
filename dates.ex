defmodule(Dates) do

  def date_parts(date_string) do
    String.split(date_string, "-", trim: true)
  end

  def julian(date_string) do
    [ year, month, day ] = date_parts(date_string)
  end
end
