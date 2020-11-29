defmodule ArticulateWookie.Input do
  @moduledoc """
  Detects inputs and plays sounds accordingly
  """

  require Logger

  use GenServer

  alias ArticulateWookie.AudioPlayer
  alias Circuits.GPIO

  def start_link(config \\ []) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  @impl GenServer
  def init(_config) do
    {:ok, configure()}
  end

  def configure() do
    {:ok, button} = GPIO.open(17, :input)
    GPIO.set_pull_mode(button, :pulldown)
    GPIO.set_interrupts(button, :both)
    %{button: button}
  end

  # on
  @impl GenServer
  def handle_info({:circuits_gpio, pin_number, _timestamp, 1}, state) do
    AudioPlayer.play()
    {:noreply, state}
  end

  # off
  @impl GenServer
  def handle_info({:circuits_gpio, pin_number, _timestamp, 0}, state) do
    {:noreply, state}
  end

end
