defmodule(War) do

  def start() do
    deck = Cards.shuffle(Cards.make_deck())
    { p1, p2 } = Cards.deal(deck, 26)
    player1 = spawn(__MODULE__, :player, [ p1 ])
    player2 = spawn(__MODULE__, :player, [ p2 ])
    play_a_round(player1, player2, [])
    send player1, :done
    send player2, :done
    :ok
  end

  def play_a_round(player1, player2, pot) do
    request_cards_from_players(player1, player2)
    round_list = receive_cards_from_players([])
    case evaluate_round_list(round_list) do
      { :tie, new_pot } -> play_a_round(player1, player2, new_pot)
      { :win, pid, new_pot } ->
        send pid, { :receive_cards, new_pot ++ pot }
        play_a_round(player1, player2, [])
      { :game_over, pid, new_pot } ->
        send pid, { :receive_cards, new_pot ++ pot }
        send pid, :winner
    end
  end

  def request_cards_from_players(player1, player2) do
    # IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    # IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
  end

  def receive_cards_from_players(round_list) do
    receive do
      { :cards, cards, pid } ->
        # IO.puts "Got #{inspect cards} from #{inspect pid}"
        round_list = [ { cards, pid } | round_list ]
        if (length(round_list) == 1) do
          receive_cards_from_players(round_list)
        else
          round_list
        end
    end    
  end  

  def get_top_card(cards) do
    case(cards) do
      [] -> :no_card
      [h|_] -> h
    end
  end

  def evaluate_round_list([respa, respb]) do
    {cardsa, pida} = respa
    {cardsb, pidb} = respb
    pot = cardsa ++ cardsb
    tct = { get_top_card(cardsa), get_top_card(cardsb) }
    case tct do
      { :no_card, _ } -> { :game_over, pidb, pot }
      { _, :no_card } -> { :game_over, pida, pot }
      { ca, cb } ->
        diff = Cards.rank(ca) - Cards.rank(cb)
        cond do
          diff == 0 -> { :tie, pot }
          diff > 0 -> { :win, pida, pot }
          diff < 0 -> { :win, pidb, pot }
        end
    end    
  end

  def player(hand) do
    IO.puts("Player #{ inspect self() } initial hand #{ inspect hand }")
    player_loop(hand)
  end

  def player_loop(hand) do
    receive do
      { :send_cards, pid } ->
        { cards, new_hand } = Cards.deal(hand, 3)
        IO.puts "#{inspect self()} new hand #{inspect new_hand}"
        send pid, { :cards, cards, self() }
        player_loop(new_hand)
      { :receive_cards, cards } ->
        IO.puts "#{inspect self()} new hand #{inspect hand++cards}"
        player_loop(hand ++ cards)
      :done ->
        IO.puts("Player #{ inspect self() } exiting")
      :winner ->
        IO.puts("Whoop whoop, I'm a winner!")
        player_loop(hand)
    end
  end

end
