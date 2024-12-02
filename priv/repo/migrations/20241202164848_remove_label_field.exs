defmodule Snowbonker.Repo.Migrations.RemoveLabelField do
  use Ecto.Migration

  def change do
    alter table(:locations) do
      remove :label
    end
  end
end
