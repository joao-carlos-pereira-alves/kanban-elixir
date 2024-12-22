defmodule KanbanWeb.Resolvers.TaskResolver do
  alias Kanban.Tasks

  def list_tasks(_parent, args, _resolution) do
    case Tasks.list_tasks(%{
           "page" => Integer.to_string(args[:page] || 1),
           "page_size" => Integer.to_string(args[:page_size] || 5),
           "priority" => args[:priority],
           "execution_location" => args[:execution_location],
           "execution_date" => args[:execution_date],
           "search_text" => args[:search_text]
         }) do
      {:ok, tasks, pagination, offset} ->
        page = String.to_integer(pagination["page"])
        page_size = String.to_integer(pagination["page_size"])
        pagination = %{page: page, per_page: page_size, total_items: offset}

        tasks =
          Enum.map(tasks, fn task ->
            updated_files =
              case task.files do
                nil ->
                  nil

                %{} = file_map ->
                  file_url = Kanban.Task.url({file_map, task})
                  filename = Map.get(file_map, :file_name, "name_not_found")
                  %{url: file_url, filename: filename}

                _ ->
                  nil
              end

            # Atualiza o campo `files` com a lista de arquivos e suas URLs
            Map.put(task, :files, updated_files)
          end)

        {:ok, %{tasks: tasks, pagination: pagination}}

      {:error, :not_found} ->
        page = 1
        page_size = 5

        {:ok, %{tasks: [], pagination: %{ page: page, total_items: 1, per_page: page_size }}}
    end
  end

  def show_task(_parent, %{id: id}, _resolution) do
    case Tasks.show(id) do
      {:error, :not_found} ->
        {:error, "Task not found"}

      {:ok, task} ->
        updated_task =
          case task.files do
            nil ->
              Map.put(task, :files, nil)

            %{} = file_map ->
              file_url = Kanban.Task.url({file_map, task})
              filename = Map.get(file_map, :file_name, "name_not_found")
              Map.put(task, :files, %{url: file_url, filename: filename})

            _ ->
              Map.put(task, :files, nil)
          end

        {:ok, updated_task}
    end
  end
end
