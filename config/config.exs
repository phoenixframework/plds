# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :plds,
  halt_on_abort: true,
  namespace: PLDS

# Configures the endpoint
config :plds, PLDSWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PLDSWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PLDS.PubSub,
  live_view: [signing_salt: "kA47bW1N"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env = config_env()

unless env == :docs do
  import_config "#{env}.exs"
end
