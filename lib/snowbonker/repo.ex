defmodule Snowbonker.Repo do
  use Ecto.Repo,
    otp_app: :snowbonker,
    adapter: Ecto.Adapters.SQLite3
end
