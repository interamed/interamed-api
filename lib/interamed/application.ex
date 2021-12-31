defmodule Interamed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InteramedWeb.Telemetry,
      {Phoenix.PubSub, name: Interamed.PubSub},
      InteramedWeb.Endpoint,
      {Mongo, [name: :database, database: database(), pool_size: 2]}
    ]

    opts = [strategy: :one_for_one, name: Interamed.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InteramedWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp database do
    Application.get_env(:interamed, :database, "anvisabot")
  end
end
