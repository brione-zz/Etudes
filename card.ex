defmodule(Card) do

  defstruct rank: :none, suit: :none

  defimpl Inspect, for: Card do
    import Inspect.Algebra

    def inspect(card, opts) do
      to_doc(to_string(card), opts)
    end
  end

  defimpl String.Chars, for: Card do

    def to_string(%Card{rank: r, suit: s}) do
      Card.rank_to_string(r)<> Card.suit_to_string(s)
    end
  end

  def suit_to_string(:hearts), do: <<0xe2,0x99,0xa5,0xef,0xb8,0x8f>>
  def suit_to_string(:diamonds), do: <<0xe2,0x99,0xa6,0xef,0xb8,0x8f>>
  def suit_to_string(:clubs), do: <<0xe2,0x99,0xa3,0xef,0xb8,0x8f>>
  def suit_to_string(:spades), do: <<0xe2,0x99,0xa0,0xef,0xb8,0x8f>>

  def rank_to_string(:a) do
    "A"
  end

  def rank_to_string(:k) do
    "K"
  end

  def rank_to_string(:q) do
    "Q"
  end

  def rank_to_string(:j) do
    "J"
  end

  def rank_to_string(r) do
    to_string(r)
  end

  def suits(type \\ :full) do
    if type == :full do
      [:hearts, :spades, :diamonds, :clubs]
    else
      [:hearts, :spades, :diamonds, :clubs]
    end
  end

  def ranks(type \\ :full) do
    if type == :full do
      [:a, :k, :q, :j, :"10", :"9", :"8", :"7", :"6", :"5", :"4", :"3", :"2"]
    else
      [:a, :k, :q, :j ]
    end 
  end

  
end
