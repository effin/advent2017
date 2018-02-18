defmodule Apa do

  defp is_prime?(n) when n in [2, 3], do: true
  defp is_prime?(n) do
    floored_sqrt = :math.sqrt(n)
                   |> Float.floor
                   |> round
    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end

  defp primeVal(n), do: if is_prime?(n), do: 0, else: 1

  def solve(b, bstop, h) do
    if b > bstop do
      h
    else
      solve(b + 17, bstop, h + primeVal(b))
    end
  end

end

IO.puts Apa.solve(106500, 123500, 0)

