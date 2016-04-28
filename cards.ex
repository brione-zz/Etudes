defmodule(Cards) do

  def make_deck() do
    ranks = ["K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "A"]
    suits = ["Hearts", "Spades", "Diamonds", "Clubs"]
    for r <- ranks, s <- suits, do: { r, s } 
  end

  def shuffle(deck) do
    :random.seed(:erlang.timestamp)
    shuffle(deck, [])
  end

  defp shuffle([], shuffled) do
    shuffled
  end

  defp shuffle(deck, shuffled) do
    { leading, [ h | t ] } = Enum.split(deck, :random.uniform(length(deck))-1)
    shuffle(leading ++ t, [h | shuffled]) 
  end

  def deal_bridge_hands() do
    deck = make_deck |> shuffle
    deal_bridge_hands(deck, { [[],[],[],[]], 0 })
  end

  defp deal_bridge_hands([], { hands, _index} ) do
    hands
  end

  defp deal_bridge_hands([card | deck], { hands, index } ) do
    new_hand = [ card | Enum.at(hands, index) ]
    new_hands = List.replace_at(hands, index, new_hand)
    new_index = case index do
      3 -> 0
      _ -> index + 1
    end
    deal_bridge_hands(deck, { new_hands, new_index })
  end

end
