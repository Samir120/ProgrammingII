defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

  def start(hunger, right, left, name, ctrl, seed) do
    spawn_link(fn -> init(hunger, right, left, name, ctrl, seed) end)
  end

  def init(hunger, right, left, name, ctrl, seed) do
    :rand.seed(:exsss, {seed, seed, seed})
    dream(hunger, right, left, name, ctrl)
  end

  # here may comes code snippet for the function initiate according to CasperKristiansson

  def dream(0, _, _, name, ctrl) do
    IO.puts("Mrs. #{name} is done eating and dreaming now")
    send(ctrl, :done)
  end
  def dream(hunger, right, left, name, ctrl) do
    IO.puts("Mrs. #{name} is feeling hungary")
    sleep(100)
    wait(hunger, right, left, name, ctrl)
  end

  def eat(hunger, right, left, name, ctrl) do
    IO.puts("Mrs. #{name} is eating")
    #sleep(100)
    Chopstick.return(right)
    Chopstick.return(left)

    dream(hunger - 1, right, left, name, ctrl)
  end

  def wait(hunger, right, left, name, ctrl) do
    IO.puts("Mrs. #{name} is waiting for chopstick")

    case Chopstick.request({:stick, right}, 100) do
      :ok ->
        IO.puts("Mrs. #{name} received right chopstick")
      case Chopstick.request({:stick, left}, 100) do
        :ok ->
          IO.puts("Mrs. #{name} has both chopsticks")
          sleep(70) # examine the timeout
          eat(hunger, right, left, name, ctrl)
        :no ->
          IO.puts("Mrs. #{name} timeouted")
          Chopstick.return(right)
          sleep(100) #back-off timer
          dream(hunger, right, left, name, ctrl)
    end
    :no ->
      IO.puts("Mrs. #{name} timeouted")
      sleep(100) #back-off timer
      dream(hunger, right, left, name, ctrl)
    end
  end

  def async_wait(hunger, right, left, name, ctrl) do
    IO.puts("Mrs. #{name} is waiting for chopstick")

    if Chopstick.request({:stick, right}, 150) == :ok &&
        Chopstick.request({:stick, left}, 150) == :ok do
      IO.puts("Mrs. #{name} has both chopsticks")
      eat(hunger, right, left, name, ctrl)
    else
      IO.puts("Mrs. #{name} failed to receive chopsticks")
      Chopstick.return(right)
      Chopstick.return(left)
      #sleep(300) #back-off timer
      dream(hunger, right, left, name, ctrl)
    end
  end


end
