defmodule(Dates) do

  def date_parts(date_string) do
    String.split(date_string, "-", trim: true)
  end

end
