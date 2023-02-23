defmodule Chopstick do

  def start() do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :ok)
        gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  #interface for user
  def request({:stick, stick}, timeout) when is_number(timeout) do
    send(stick, {:request, self()})
    receive do
      :ok -> :ok
    after timeout ->
      :no
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    send(stick, :quit)
  end

end
