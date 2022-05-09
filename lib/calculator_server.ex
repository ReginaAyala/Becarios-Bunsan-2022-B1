defmodule Calculator do

  def init(n) do
    calc = receive do
      {:sum, m, pid} -> send(pid, {:state, n + m})  
      n + m
      {:mult, m, pid} -> send(pid, {:state, n * m})
      n * m
      {:rest, m, pid} -> send(pid, {:state, n - m})
      n - m
      {:div, m, pid} -> send(pid, {:state, n / m}) 
      n / m
      _ -> n
    end
    init(calc)
  end
end