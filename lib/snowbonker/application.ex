defmodule Snowbonker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SnowbonkerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:snowbonker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Snowbonker.PubSub},
      Snowbonker.Poller,
      SnowbonkerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Snowbonker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SnowbonkerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
