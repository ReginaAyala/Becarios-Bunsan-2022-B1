defmodule FizzBuzz do
    def fizzbuzz (n) do
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