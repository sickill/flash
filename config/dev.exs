use Mix.Config

env = &System.get_env/1

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :flash, FlashWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :flash, FlashWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/flash_web/(live|views)/.*(ex)$",
      ~r"lib/flash_web/templates/.*(eex)$"
    ]
  ]

config :flash,
  ttl_options: [
    {"10 seconds", 10},
    {"5 minutes", 300},
    {"30 minutes", 1800},
    {"1 hour", 3600},
    {"4 hours", 14400},
    {"12 hours", 43200},
    {"1 day", 86400},
    {"3 days", 259_200},
    {"7 days", 604_800}
  ]

if redis_url = env.("REDIS_URL") do
  config :flash, secrets_store: Flash.KvStore.Redis
  config :flash, Flash.KvStore.Redis, url: redis_url
end

if s3_bucket = env.("S3_BUCKET") do
  config :flash, secrets_store: Flash.KvStore.S3

  config :flash, Flash.KvStore.S3,
    bucket: s3_bucket,
    prefix: env.("S3_PREFIX"),
    host: env.("S3_HOST")
end

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
