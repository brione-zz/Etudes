defmodule(Dates) do

  def date_parts(date_string) do
    String.split(date_string, "-", trim: true)
  end

  def julian(date_string) do
    [ year, month, day ] = to_ints(date_parts(date_string), [])
    month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30 ]
    months_total = month_total(month, month_days, 0) + day
    cond do
      is_leap_year?(year) and (month > 2) ->
        months_total + 1
      true ->
        months_total
    end
  end

  defp month_total(1, _days, total) do
    total
  end

  defp month_total(m, [h|t], total) do
    month_total(m - 1, t, total + h)
  end

  defp to_ints([], int_list) do
    Enum.reverse(int_list)
  end

  defp to_ints([h | t], int_list) do
    to_ints(t, [:erlang.binary_to_integer(h) | int_list ])
  end

  defp is_leap_year?(year) do
    (rem(year, 4) == 0 and rem(year, 100) != 0) or (rem(year, 400) == 0)
  end
end
