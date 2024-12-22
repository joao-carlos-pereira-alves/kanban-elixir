defmodule KanbanWeb.Resolvers.PaginationResolver do
  def pagination(parent, _args, _resolution) do
    pagination = parent[:pagination] || %{}
    {:ok, pagination}
  end
end
