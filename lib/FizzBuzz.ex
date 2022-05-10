defmodule FizzBuzz do
  @moduledoc """
  This is FizzBuzz.
  This module get a list of numbers and it is commissioned from every multiple of 3 returns the word "fizz",
  every multiple of 5 return the word "Buzz" and the multiple of 3 and 5 return 
  the word "FizzBuzz"
  """
  def fizzbuzz(n) do
    Enum.each(1..n, fn x ->
      cond do
        rem(x, 3) == 0 and rem(x, 5) == 0 -> IO.puts("FizzBuzz")
        rem(x, 5) == 0 -> IO.puts("Buzz")
        rem(x, 3) == 0 -> IO.puts("Fizz")
        true -> IO.puts(x)
      end
    end)
  end
end
