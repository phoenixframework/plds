import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plds, PLDSWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "4uFwNlOnyppVcDWeVcNUgGPOYQD+y7F4mTkconBPSqAleqXvd2wmmcLCqXJanfon",
  server: false

config :plds, :cookie, :"my-plds-test-cookie"

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
