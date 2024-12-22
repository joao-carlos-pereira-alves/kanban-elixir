defmodule Kanban.Tasks.Create do
  alias Kanban.Tasks.Task
  alias Kanban.Repo

  def call(params) do
    params
    |> Task.changeset()
    |> Repo.insert()
  end
end
