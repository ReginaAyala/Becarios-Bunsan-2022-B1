defmodule RabbitMQ.System do
  @doc """
  Creates the exchaange, the queues and their bindings.
  If the exchange and queues already exist, does nothing.
  """
  def setup(exchange_name, queue_names) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Exchange.declare(channel, exchange_name, :direct)

    Enum.each(queue_names, fn queue ->
      AMQP.Queue.declare(channel, queue)
      AMQP.Queue.bind(channel, queue, exchange_name, routing_key: queue)
    end)

    AMQP.Connection.close(connection)
  end
end

defmodule RabbitMQ.Producer do
  @doc """
  Sends n messages with payload 'msg' and the given routing key.
  """
  def send(exchange, routing_key, msg, n) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Exchange.declare(channel, exchange, :direct)

    Enum.each(1..n, fn x ->
      AMQP.Basic.publish(channel, exchange, routing_key, msg)
      x
    end)

    AMQP.Connection.close(connection)
  end
end

defmodule RabbitMQ.Consumer do
  @doc """
  Creates a process that listens for messages on the given queue.
  When a message arrives, it writes to the log the pid, queue_name and msg.
  Example:
    iex> {:ok, pid} = Consumer.start("orders")
  """
  def start(queue_name) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    pid = spawn(RabbitMQ.Consumer, :wait_for_messages, [channel])
    AMQP.Basic.consume(channel, queue_name, pid, no_ack: true)
    pid
  end

  @doc """
  Stops the given consumer.
  Example:
    iex> Consumer.stop("orders")
  """
  def stop(pid) do
    Process.exit(pid, :kill)
  end

  def wait_for_messages(channel) do
    receive do
      {:basic_deliver, payload, meta} ->
        IO.puts(" [x] Received [#{meta.routing_key}] #{payload}")
    end

    wait_for_messages(channel)
  end
end