defmodule(War) do

  def start() do
    deck = Cards.shuffle(Cards.make_deck())
    { p1, p2 } = Cards.deal(deck, 26)
    player1 = spawn(__MODULE__, :player, [ p1 ])
    player2 = spawn(__MODULE__, :player, [ p2 ])
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
    game_loop(player1, player2, {[], []})
    :ok
  end

  def game_loop(player1, player2, { play_list, pot }) do
    receive do
      { :cards, cards, pid } ->
        IO.puts "Got #{inspect cards} from #{inspect pid}"
        play_list = [ { cards, pid } | play_list ]
        if (length(play_list) == 2) do
          [{handa, pida}, {handb, pidb}] = play_list
          if length(handa) == 0 do
            IO.puts "Winner is #{inspect pidb}. Informing him"
            send pidb, {:receive_cards, pot }
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
            game_loop(player1, player2, { [], [] })
          end
          if length(handb) == 0 do
            IO.puts "Winner is #{inspect pida}. Informing him"
            send pida, {:receive_cards, pot }
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
            game_loop(player1, player2, { [], [] })
          end
          diff = Cards.rank(hd handa) - Cards.rank(hd handb)
          cond do
            diff == 0 ->
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
              game_loop(player1, player2, { [], handa ++ handb ++ pot })
            diff > 0 -> # the first pida wins, whoever that is
              IO.puts "Winner is #{inspect pida}. Informing him"
              send pida, {:receive_cards, pot }
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
              game_loop(player1, player2, { [], [] })
            diff < 0 -> # pidb wins
              IO.puts "Winner is #{inspect pidb}. Informing him"
              send pidb, {:receive_cards, pot }
    IO.puts "Telling #{inspect player1} to send cards"
    send player1, { :send_cards, self() }
    IO.puts "Telling #{inspect player2} to send cards"
    send player2, { :send_cards, self() }
              game_loop(player1, player2, { [], [] })
          end
        else
          game_loop(player1, player2, { play_list, pot })
        end
      { :done, pid } ->
        IO.puts "Got :done from #{inspect pid}"
        if length play_list == 1 do
          :exiting
        else
          game_loop(player1, player2, { [ pid ], [] })
        end 
    end
  end

  def player(hand) do
    IO.puts("Player #{ inspect self() } got hand of #{ inspect hand }")
    player_loop(hand)
  end

  def player_loop(hand) do
    receive do
      { :send_cards, pid } ->
        { cards, new_hand } = Cards.deal(hand, 3)
        IO.puts "#{inspect self()} sending #{inspect cards}"
        send pid, { :cards, cards, self() }
        player_loop(new_hand)
      { :receive_cards, cards } ->
        IO.puts "#{inspect self()} received #{inspect cards}"
        player_loop(hand ++ cards)
      { :done, pid } ->
        IO.puts("Player #{ inspect self() } exiting")
        send pid, {:done, self()}
    end
  end

end
