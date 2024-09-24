defmodule PC.Pagination do
  @moduledoc """
  Pagination is the method of splitting up content into discrete pages. It specifies the total number of pages and inidicates to a user the current page within the context of total pages.
  """
  use Phoenix.Component

  import PC.PaginationInternal

  alias PC.Link

  attr :path, :string, default: "/:page", doc: "page path"
  attr :class, :string, default: "", doc: "parent div CSS class"

  attr :link_type, :string,
    default: "a",
    values: ["a", "live_patch", "live_redirect", "button"]

  attr :event, :boolean,
    default: false,
    doc:
      "whether to use `phx-click` events instead of linking. Enabling this will disable `link_type` and `path`."

  attr :target, :any,
    default: nil,
    doc:
      "the LiveView/LiveComponent to send the event to. Example: `@myself`. Will be ignored if `event` is not enabled."

  attr :total_pages, :integer, default: nil, doc: "sets a total page count"
  attr :current_page, :integer, default: nil, doc: "sets the current page"
  attr :sibling_count, :integer, default: 1, doc: "sets a sibling count"
  attr :boundary_count, :integer, default: 1, doc: "sets a boundary count"

  attr :show_boundary_chevrons, :boolean,
    default: false,
    doc: "whether to show prev & next buttons at boundary pages"

  attr :rest, :global

  @doc """
  In the `path` param you can specify :page as the place your page number will appear.
  e.g "/posts/:page" => "/posts/1"
  """

  def pagination(assigns) do
    ~H"""
    <div {@rest} class={"#{@class} flex"}>
      <ul class="inline-flex -space-x-px text-sm font-medium">
        <%= for item <- get_pagination_items(@total_pages, @current_page, @sibling_count, @boundary_count) do %>
          <%= if item.type == "prev" and (item.enabled? or @show_boundary_chevrons) do %>
            <div>
              <Link.a
                phx-click={if @event, do: "goto-page"}
                phx-target={if @event, do: @target}
                phx-value-page={item.number}
                link_type={if @event, do: "button", else: @link_type}
                to={if not @event, do: get_path(@path, item.number, @current_page)}
                class="mr-2 inline-flex items-center justify-center rounded leading-5 px-2.5 py-2 bg-white enabled:hover:bg-gray-50 dark:bg-gray-900 enabled:dark:hover:bg-gray-800 border dark:border-gray-700 border-gray-200 text-gray-600 enabled:hover:text-gray-800 disabled:opacity-50"
                disabled={!item.enabled?}
              >
                <Heroicons.chevron_left solid class="w-5 h-5 text-gray-600 dark:text-gray-400" />
              </Link.a>
            </div>
          <% end %>

          <%= if item.type == "page" do %>
            <li>
              <%= if item.current? do %>
                <span class={get_box_class(item)}><%= item.number %></span>
              <% else %>
                <Link.a
                  phx-click={if @event, do: "goto-page"}
                  phx-target={if @event, do: @target}
                  phx-value-page={item.number}
                  link_type={if @event, do: "button", else: @link_type}
                  to={if not @event, do: get_path(@path, item.number, @current_page)}
                  class={get_box_class(item)}
                >
                  <%= item.number %>
                </Link.a>
              <% end %>
            </li>
          <% end %>

          <%= if item.type == "..." do %>
            <li>
              <span class="inline-flex items-center justify-center leading-5 px-3.5 py-2 bg-white border dark:bg-gray-900 dark:border-gray-700 border-gray-200 text-gray-400">
                ...
              </span>
            </li>
          <% end %>

          <%= if item.type == "next" and (item.enabled? or @show_boundary_chevrons) do %>
            <div>
              <Link.a
                phx-click={if @event, do: "goto-page"}
                phx-target={if @event, do: @target}
                phx-value-page={item.number}
                link_type={if @event, do: "button", else: @link_type}
                to={if not @event, do: get_path(@path, item.number, @current_page)}
                class="ml-2 inline-flex items-center justify-center rounded leading-5 px-2.5 py-2 bg-white enabled:hover:bg-gray-50 dark:bg-gray-900 enabled:dark:hover:bg-gray-800 dark:border-gray-700 border border-gray-200 text-gray-600 enabled:hover:text-gray-800 disabled:opacity-50"
                disabled={!item.enabled?}
              >
                <Heroicons.chevron_right solid class="w-5 h-5 text-gray-600 dark:text-gray-400" />
              </Link.a>
            </div>
          <% end %>
        <% end %>
      </ul>
    </div>
    """
  end

  defp get_box_class(item) do
    base_classes = "inline-flex items-center justify-center leading-5 px-3.5 py-2 border border-gray-200 dark:border-gray-700"

    active_classes =
      if item.current?,
        do: "text-gray-800 bg-gray-100 dark:bg-gray-800 dark:text-gray-300",
        else: "text-gray-600 bg-white hover:bg-gray-50 hover:text-gray-800 dark:bg-gray-900 dark:text-gray-400 dark:hover:bg-gray-800 dark:hover:text-gray-400"

    rounded_classes =
      case item do
        %{first?: true, last?: true} ->
          "rounded"

        %{first?: true, last?: false} ->
          "rounded-l"

        %{first?: false, last?: true} ->
          "rounded-r"

        _ ->
          "inline-flex items-center justify-center leading-5 px-3.5 py-2 border border-gray-200 dark:border-gray-700--rounded-catch-all"
      end

    [base_classes, active_classes, rounded_classes]
  end

  defp get_path(path, page_number, current_page) when is_binary(path) do
    # replace on `%3Apage` or `:page` in case we receive an URI encoded path
    fun = &String.replace(path, ~r/%3Apage|:page/, Integer.to_string(&1))
    get_path(fun, page_number, current_page)
  end

  defp get_path(fun, "previous", current_page) when is_function(fun, 1) do
    get_path(fun, current_page - 1, current_page)
  end

  defp get_path(fun, "next", current_page) when is_function(fun, 1) do
    get_path(fun, current_page + 1, current_page)
  end

  defp get_path(fun, page_number, _current_page) when is_function(fun, 1) do
    then(page_number, fun)
  end
end
