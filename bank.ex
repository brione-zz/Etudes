defmodule Bank do

  def account(balance) do
    account_transaction(balance)

  end

  def account_transaction(balance) do
    trans = IO.gets("D\)eposit, W\)ithdraw, B\)alance, Q\)quit: ")
    |> String.first
    |> code_to_transaction
    case trans do
      :withdrawal ->
        process_withdrawal(balance)
      :deposit ->
        process_deposit(balance)
      :balance ->
        IO.puts("Balance inquiry #{balance}")
        account_transaction(balance)
      :quit ->
        IO.puts("Quitting")
    end
  end

  def code_to_transaction(code) do
    case String.upcase(code) do
      "D" -> :deposit
      "W" -> :withdrawal
      "B" -> :balance
      "Q" -> :quit
      _ -> :unkown
    end
  end

  def process_withdrawal(balance) do
    amount = AskArea.get_number("Amount to withdraw: ")
    cond do
      amount < 0.0 ->
        IO.puts("Withdrawal amount is negative: #{amount}")
        account_transaction(balance)
      amount > balance ->
        IO.puts("Withdrawal amount greater than balance: #{amount}")
        account_transaction(balance)
      true ->
        IO.puts("Successful withdrawal")
        account_transaction(balance - amount)
    end
  end

  def process_deposit(balance) do
    amount = AskArea.get_number("Amount to deposit: ")
    cond do
      amount < 0.0 ->
        IO.puts("Deposit amount is negative: #{amount}")
        account_transaction(balance)
      true ->
        IO.puts("Successful deposit")
        account_transaction(balance + amount)
    end
  end

end
