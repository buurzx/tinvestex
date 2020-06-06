use Mix.Config

config :tinvestex,
  token: System.get_env("TOKEN"),
  log: System.get_env("LOG")
