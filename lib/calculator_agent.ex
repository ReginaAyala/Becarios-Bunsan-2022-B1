defmodule CalculatorAgent do
  @moduledoc """
   This is module Calculator agent.
   This Calculator use agent for modify the process.
   It get a value and return a math operation
  """
  def init(init_val) do
    {_, pid} = Agent.start(fn -> init_val end)
    pid
  end

  def sum(pid, val), do: calc({:sum, val, pid})
  def rest(pid, val), do: calc({:rest, val, pid})
  def mult(pid, val), do: calc({:mult, val, pid})
  def div(pid, val), do: calc({:div, val, pid})
  def state(pid), do: calc({:state, pid})

  defp calc(operation) do
    case operation do
      {:sum, val, pid} -> Agent.update(pid, &(&1 + val))
      {:rest, val, pid} -> Agent.update(pid, &(&1 - val))
      {:mult, val, pid} -> Agent.update(pid, &(&1 * val))
      {:div, val, pid} -> Agent.update(pid, &(&1 / val))
      {:state, pid} -> Agent.get(pid, & &1)
      _ -> IO.puts("Invalid request")
    end
  end
end
