defmodule Bank do

  def account(balance) do
    trans = IO.gets("D\)eposit, W\)ithdraw, B\)alance, Q\)quit: ")
    |> String.upcase
    |> String.first
    if trans != "Q" do
      new_balance = transaction(trans, balance)
      account(new_balance)
    else
        IO.puts("Quitting")
    end
  end

  def transaction(code, balance) do
    case code do
      "W" ->
        amount = AskArea.get_number("Amount to withdraw? ")
        cond do
          amount < 0.0 ->
            :error_logger.warning_msg(
                "Withdrawal amount is negative: $#{amount}\n")
            new_balance = balance
          amount > balance ->
            :error_logger.warning_msg(
                "Withdrawal amount greater than balance: $#{amount}\n")
            new_balance = balance
          true ->
            :error_logger.info_msg("Successful withdrawal $#{amount}\n")
            IO.puts("Successful withdrawal of $#{amount}")
            IO.puts("Your new balance is $#{balance - amount}")
            new_balance = balance - amount
        end
      "D" ->
        amount = AskArea.get_number("Amount to deposit? ")
        cond do
          amount >= 10000 ->
            :error_logger.warning_msg(
                "Large deposit: $#{amount}\n")
            IO.puts("Your deposit of $#{amount} may be subject to hold.")
            IO.puts("Your new balance is $#{balance + amount}")
            new_balance = balance + amount
          amount < 0.0 ->
            :error_logger.error_msg(
                "Deposit amount is negative: $#{amount}\n")
            IO.puts("Deposits may not be less than zero.")
            new_balance = balance
          true ->
            :error_logger.info_msg("Successful deposit of $#{amount}\n")
            IO.puts("Your new balance is $#{balance + amount}")
            new_balance = balance + amount
        end
      "B" ->
        :error_logger.info_msg("Balance inquiry $#{balance}\n")
        IO.puts("Your balance is $#{balance}")
        new_balance = balance
      _ ->
        IO.puts("Unknown command #{code}")
        new_balance = balance
    end
  end

end
