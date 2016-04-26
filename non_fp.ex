defmodule(NonFP) do

  def some_teeth() do
    'TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT'
  end

  def some_more_teeth() do
    'FTTTTTTTFTTTTTTFFTTTTTTTTTTTTTTF'
  end

  def generate_pockets(teeth_char_list, probability) do
    :random.seed(:erlang.timestamp())
    generate_pockets(teeth_char_list, probability, [])
  end

  def generate_pockets([], _probability, pocket_list) do
    Enum.reverse pocket_list
  end

  def generate_pockets([present|rest], probability, pocket_list) do
    cond do
      present == ?T -> 
        generate_pockets(rest, probability, 
          [generate_tooth(probability) | pocket_list])
      present == ?F -> 
        generate_pockets(rest, probability, [[0] | pocket_list])
    end
  end

  def generate_tooth(probability) do
    if :random.uniform() < probability do
      generate_tooth(2, 6, [])
    else
      generate_tooth(3, 6, [])
    end
  end

  def generate_tooth(_base, 0, the_tooth) do
    the_tooth
  end

  def generate_tooth(base, left, the_tooth) do
    generate_tooth(base, left-1, 
      [(:random.uniform(3)-2) + base | the_tooth])
  end

  
end
