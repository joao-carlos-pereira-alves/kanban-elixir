defmodule Kanban.Tasks.Get do
  import Ecto.Query

  alias Kanban.Tasks.Task
  alias Kanban.Repo

  def list_tasks(params \\ %{}) do
    query  = apply_filters(params)
    offset = count_items(query)
    query  = paginate(query, params)

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
      _error -> query  # Se o formato da data for inválido, não aplica o filtro
    end
  end

  defp apply_search_description_filter(query, description) do
    where(query, [t], ilike(t.description, ^"%#{description}%") or ilike(t.description, ^"%#{description}%"))
  end

  defp apply_search_name_filter(query, name) do
    where(query, [t], ilike(t.name, ^"%#{name}%") or ilike(t.name, ^"%#{name}%"))
  end

  # defp apply_order(query, order_filter) do
  #   order_expressions =
  #     case order_filter do
  #       nil -> [desc: :inserted_at]
  #       "inserted_at_asc"  -> [asc: :inserted_at]
  #       "inserted_at_desc" -> [desc: :inserted_at]
  #     end

  #   order_by(query, ^order_expressions)
  # end

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
      case Map.fetch(params, "description") do
        {:ok, nil} -> query
        {:ok, description} -> apply_search_description_filter(query, description)
        :error -> query
      end

    query =
      case Map.fetch(params, "name") do
        {:ok, nil} -> query
        {:ok, name} -> apply_search_name_filter(query, name)
        :error -> query
      end

    # query = apply_order(query, Map.get(params, "order_by"))

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
