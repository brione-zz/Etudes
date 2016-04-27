defmodule(College) do

  def make_room_list(name) do
    {:ok, res} = File.open(name, [:read, :utf8])
    result = read_lines(res, Map.new())
    File.close(res)
    result
  end

  def read_lines(res, result) do
    case line = IO.read(res, :line) do
      :eof -> result
      _ ->
        [ id, name, num, room ] = String.split(line, ",", trim: true)
        course = name <> " " <> num
        key = String.rstrip(room, ?\n)
        read_lines(res,  Map.update(result, key, [ course ], &([course|&1])))
    end
  end

end
