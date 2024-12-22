defmodule KanbanWeb.TaskController do
  use KanbanWeb, :controller

  alias Kanban.Tasks

  def list(conn, %{"page" => page, "page_size" => page_size} = params) do
    case Tasks.list_tasks(params) do
      {:ok, tasks, pagination, offset} ->
        conn
        |> put_status(:ok)
        |> json(%{tasks: tasks, pagination: pagination, offset: offset})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No tasks found"})
    end
  end
end
