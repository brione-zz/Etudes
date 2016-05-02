defmodule(Card) do

  defstruct rank: :none, suit: :none

  defimpl Inspect, for: Card do
    import Inspect.Algebra

    def inspect(card, opts) do
      [_|card_list] = Map.to_list(card) 
      concat ["#Card<", to_doc(card_list, opts), ">"]
    end
  end

end
