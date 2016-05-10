defmodule PhoneCall do

  defstruct number: "000-000-0000", start_date: "1900-01-01", 
      start_time: "00:00:00", end_date: "1900-01-01", end_time: "00:00:00"

end

defmodule PhoneETS do

  def setup(filename) do
    {:ok, res} = File.open(filename, [:read, :utf8])
    :ets.new(:phone_ets, [:bag, :named_table])
    read_lines(res)
    File.close(res)
  end

  def done() do
    :ets.delete(:phone_ets)
  end

  def summary() do
    get_numbers(:ets.first(:phone_ets), [])
    |> Enum.map(&process_a_number/1)
  end

  defp get_numbers(:"$end_of_table", acc) do
    acc
  end

  defp get_numbers(num, acc) do
    get_numbers(:ets.next(:phone_ets, num), [num|acc])
  end

  defp process_a_number(num) do
    {num, List.foldl(:ets.lookup(:phone_ets, num), 0, &sum_call/2)}
  end

  defp sum_call({_num, call}, acc) do
    acc + calculate_call_minutes(call)
  end    

  def summary(number) do
    [number] |> Enum.map(&process_a_number/1)
  end

  defp read_lines(res) do
    case line = IO.read(res, :line) do
      :eof -> :eof
      _ ->
        [ num, fd, ft, td, tt ] = line 
        |> String.rstrip(?\n)
        |> String.split(",", trim: true)
        call = %PhoneCall{number: num, 
            start_date: convert_date(fd), 
            start_time: convert_time(ft),
            end_date: convert_date(td), 
            end_time: convert_time(tt)}
        :ets.insert(:phone_ets, { num, call })
        read_lines(res)  
    end
  end

  defp calculate_call_minutes(%PhoneCall{ start_time: st, start_date: sd, 
      end_date: ed, end_time: et}) do
    (:calendar.datetime_to_gregorian_seconds({ed, et}) - 
        :calendar.datetime_to_gregorian_seconds({sd, st}) + 59) |> div(60)
  end

  defp convert_date(a_date) do
    a_date 
    |> String.split("-") 
    |> Enum.map(&:erlang.binary_to_integer/1)
    |> List.to_tuple
  end
  
  defp convert_time(a_time) do
    a_time
    |> String.split(":")
    |> Enum.map(&:erlang.binary_to_integer/1)
    |> List.to_tuple
  end

end
