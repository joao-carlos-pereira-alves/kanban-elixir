defmodule Kanban.Tasks.Get do
  import Ecto.Query

  alias Kanban.Tasks.Task
  alias Kanban.Repo

  def list_tasks(params \\ %{}) do
    query = apply_filters(params)
    offset = count_items(query)
    query = paginate(query, params)

    case Repo.all(query) do
      [] -> {:error, :not_found}
      tasks -> {:ok, tasks, params, offset}
    end
  end

  def call(id) do
    case Repo.get(Task, id) do
      nil -> {:error, :not_found}
      task -> {:ok, task}
    end
  end

  defp apply_priority_filter(query, priority) do
    where(query, [t], t.priority == ^String.to_existing_atom(priority))
  end

  defp apply_execution_location_filter(query, execution_location) do
    where(query, [t], t.execution_location == ^String.to_existing_atom(execution_location))
  end

  defp apply_execution_date_filter(query, execution_date) do
    case Date.from_iso8601(execution_date) do
      {:ok, date} -> where(query, [t], t.execution_date == ^date)
      # Se o formato da data for inválido, não aplica o filtro
      _error -> query
    end
  end


  def apply_search_text_filter(query, search_text) do
    where(
      query,
      [t],
      ilike(t.name, ^"%#{search_text}%") or ilike(t.description, ^"%#{search_text}%")
    )
  end

  defp apply_filters(params) do
    query = from(t in Task)

    query =
      case Map.fetch(params, "priority") do
        {:ok, nil} -> query
        {:ok, priority} -> apply_priority_filter(query, priority)
        :error -> query
      end

    query =
      case Map.fetch(params, "execution_location") do
        {:ok, nil} -> query
        {:ok, execution_location} -> apply_execution_location_filter(query, execution_location)
        :error -> query
      end

    query =
      case Map.fetch(params, "execution_date") do
        {:ok, nil} -> query
        {:ok, execution_date} -> apply_execution_date_filter(query, execution_date)
        :error -> query
      end

    query =
      case Map.fetch(params, "search_text") do
        {:ok, nil} -> query
        {:ok, search_text} -> apply_search_text_filter(query, search_text)
        :error -> query
      end

    query
  end

  defp paginate(query, params) do
    per_page = Map.get(params, "page_size", "5") |> String.to_integer()
    page = Map.get(params, "page", "1") |> String.to_integer()

    offset = (page - 1) * per_page

    limit(query, ^per_page)
    |> offset(^offset)
  end

  defp count_items(query) do
    query
    |> Repo.all()
    |> length()
  end
end
