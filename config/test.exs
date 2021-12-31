import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :interamed, InteramedWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Z/dSmW18qPrLECDBrw2Pvuuexcru4MGMrRiZByEU0gM9b7WqNTxklcSeQLNGgSVS",
  server: false

# In test we don't send emails.
config :interamed, Interamed.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :interamed, database: "anvisabot"
