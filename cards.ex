defmodule(Cards) do

  def make_deck(type \\ :full) do
    ranks = if type == :full do
      [:a, :k, :q, :j, :"10", :"9", :"8", :"7", :"6", 
          :"5", :"4", :"3", :"2"]
    else
      [:a, :k, :q, :j]
    end
    suits = if type == :full do
      [:hearts, :spades, :diamonds, :clubs]
    else
      [:hearts, :spades, :diamonds, :clubs]
    end
    for r <- ranks, s <- suits, do: %Card{ rank: r, suit: s } 
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
    hands = deal_bridge_hands(deck, { [[],[],[],[]], 0 })
    for h <- hands, do: sort_bridge_hand(h) 
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

  def rank_suit(%Card{suit: :hearts}), do: 400
  def rank_suit(%Card{suit: :spades}), do: 300
  def rank_suit(%Card{suit: :diamonds}), do: 200
  def rank_suit(%Card{suit: :clubs}), do: 100

  def rank(%Card{rank: :a}), do: 14
  def rank(%Card{rank: :k}), do: 13
  def rank(%Card{rank: :q}), do: 12
  def rank(%Card{rank: :j}), do: 11
  def rank(%Card{rank: r}) do
    { val, "" } = Integer.parse(to_string(r))
    val
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
