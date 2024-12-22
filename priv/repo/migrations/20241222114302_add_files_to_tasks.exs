defmodule Kanban.Repo.Migrations.AddFilesToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :files, :string
    end
  end
end
