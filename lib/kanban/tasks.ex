defmodule Kanban.Tasks do
  alias Kanban.Tasks.Get
  alias Kanban.Tasks.Create

  defdelegate list_tasks(params), to: Get, as: :list_tasks
  defdelegate show(id), to: Get, as: :call
  defdelegate create(params), to: Create, as: :call
end
