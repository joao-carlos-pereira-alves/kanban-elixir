defmodule Kanban.Repo.Migrations.AddStatusToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :status, :string, default: "to_do"
    end
  end
end
