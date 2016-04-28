defmodule(Cards) do

  def make_deck() do
    ranks = ["K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2", "A"]
    suits = ["Hearts", "Spades", "Diamonds", "Clubs"]
    for r <- ranks, s <- suits, do: { r, s } 
  end

end
