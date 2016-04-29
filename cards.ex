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

  def sort_bridge_hand(hand) do
    Enum.sort(hand, &bridge_sort/2)
  end

  def bridge_sort(c1, c2) do
    rank_bridge_card(c1) >= rank_bridge_card(c2)
  end

  def rank_suit({_r,s}) do
    case s do
      "Hearts" -> 400
      "Spades" -> 300
      "Diamonds" -> 200
      "Clubs" -> 100
    end
  end

  def rank({r, _s}) do
    case r do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      _ -> 
        {val, _} = Integer.parse(r)
        val
    end
  end
 
  def rank_bridge_card(card) do
    rank_suit(card) + rank(card)
  end

  def empty_hands(num) do
    for _ <- 1..num, do: []
  end

  @doc """
  Pull the top num_cards cards from deck and return list of cards and the new
  deck via a tuple like so { cards_list, new_deck }
  """
  def deal(deck, num_cards) do
    Enum.split(deck, num_cards)
  end

  def push_card(card, stack) do
    [ card | stack ]
  end

  def draw_card([]) do
    { :error, [] }
  end

  def draw_card([h | rest]) do
    { h, rest }    
  end
end
