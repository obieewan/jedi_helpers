# General application configuration
import Config

config :ex_cldr, default_backend: JediHelpers.Internal.Cldr
config :ex_money, auto_start_exchange_rate_service: false
