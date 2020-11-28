defmodule ArticulateWookie.AudioPlayer do

  require Logger

  use GenServer

  @type state :: %{
    audio_command: String.t(),
    audio_file: String.t()
  }

  # Client

  def start_link(config \\ []) do
    Logger.info("Starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def play() do
    GenServer.cast(__MODULE__, {:play})
  end

  # Server

  @impl GenServer
  def init(_config) do
    {:ok, configure()}
  end

  def configure() do
    # Enable audio output to microphone jack
    :os.cmd('amixer cset numid=3 1')
    # Set volume to 50
    :os.cmd('amixer cset numid=1 80%')

    Application.get_env(:articulate_wookie, :audio_player)
    |> Enum.into(Map.new())
  end

  @impl GenServer
  def handle_cast({:play}, %{audio_command: audio_command, audio_file: audio_file} = state) do
    path = Path.join(:code.priv_dir(:articulate_wookie), audio_file)
    command = '#{audio_command} #{path}'
    Logger.debug("Executing #{command}")
    :os.cmd(command)
    {:noreply, state}
  end



end
