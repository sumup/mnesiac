defmodule Mnesiac.Supervisor do
  @moduledoc false
  require Logger
  use Supervisor

  def start_link([_config, opts] = args) do
    Supervisor.start_link(__MODULE__, args, opts)
  end

  def start_link([config]) do
    start_link([config, []])
  end

  @impl true
  def init([hosts_fn, opts]) do
    config = apply(hosts_fn,[])
    Logger.info("[mnesiac:#{node()}] starting with hosts: #{inspect(config)}")
    :ok = Mnesiac.init_mnesia(config)
    Logger.info("[mnesiac:#{node()}] mnesiac started")

    opts = Keyword.put(opts, :strategy, :one_for_one)
    Supervisor.init([], opts)
  end
end
