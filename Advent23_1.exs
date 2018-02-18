input = File.read("input23.txt")
program = String.split(elem(input, 1), "\n")
reg = {0, 0, 0, 0, 0, 0, 0, 0}

defmodule Apa do

  defp charToIndex(s) do
    hd(to_charlist(s)) - ?a
  end

  defp getValue(s, reg) do
    if Integer.parse(String.trim(s)) == :error do
      elem(reg, charToIndex(s))
    else
      elem(Integer.parse(String.trim(s)), 0)
    end
  end

  defp set(reg, t, v) do
    put_elem(reg, t, v)
  end

  defp parseCmd(s), do: String.split(s, " ")

  defp nextPos(c, reg, pos, countMul) do
    if hd(c) == "mul" do
      {set(reg, charToIndex(hd(tl(c))), getValue(hd(tl(c)), reg) * getValue(hd(tl(tl(c))), reg)), pos + 1, countMul + 1}
    else
      if hd(c) == "set" do
        {set(reg, charToIndex(hd(tl(c))), getValue(hd(tl(tl(c))), reg)), pos + 1, countMul}
      else
        if hd(c) == "sub" do
          {set(reg, charToIndex(hd(tl(c))), getValue(hd(tl(c)), reg) - getValue(hd(tl(tl(c))), reg)), pos + 1, countMul}
        else
          if hd(c) == "jnz" do
            if getValue(hd(tl(c)), reg) == 0 do
              {reg, pos + 1, countMul}
            else
              {reg, pos + getValue(hd(tl(tl(c))), reg), countMul}
            end
          else
            "oupps"
          end
        end
      end
    end
  end

  def run(program, {reg, pos, countMul}) do
    if pos < 0 or pos >= Enum.count(program) do
      countMul
    else
      run(program, nextPos(parseCmd(Enum.at(program, pos)), reg, pos, countMul))
    end
  end
end

IO.puts Apa.run(program, {reg, 0, 0})
