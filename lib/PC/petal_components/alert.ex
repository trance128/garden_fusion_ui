defmodule PC.Alert do
  use Phoenix.Component

  attr(:color, :string,
    default: "info",
    values: ["info", "success", "warning", "danger"]
  )

  attr(:with_icon, :boolean, default: false, doc: "adds some icon base classes")
  attr(:class, :any, default: "", doc: "CSS class for parent div")
  attr(:heading, :string, default: nil, doc: "label your heading")
  attr(:label, :string, default: nil, doc: "label your alert")
  attr(:rest, :global)

  attr(:close_button_properties, :list,
    default: nil,
    doc: "a list of properties passed to the close button"
  )

  slot(:inner_block)

  def alert(assigns) do
    assigns =
      assigns
      |> assign(:classes, alert_classes(assigns))

    ~H"""
    <%= unless label_blank?(@label, @inner_block) do %>
      <div {@rest} class={@classes}>
        <%= if @with_icon do %>
          <div class="self-start flex-shrink-0 pt-0.5 w-6 h-6">
            <.get_icon color={@color} />
          </div>
        <% end %>

        <div class="w-full grow-0">
          <div class="flex items-start justify-between">
            <div>
              <%= if @heading do %>
                <div class="pt-1 font-bold">
                  <%= @heading %>
                </div>
              <% end %>

              <div class="py-1 font-medium">
                <%= render_slot(@inner_block) || @label %>
              </div>
            </div>

            <%= if @close_button_properties do %>
              <button
                class={["flex p-2 hover:cursor-pointer hover:rounded", get_dismiss_icon_classes(@color)]}
                {@close_button_properties}
              >
                <Heroicons.x_mark solid class="self-start w-4 h-4" />
              </button>
            <% end %>
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  defp alert_classes(opts) do
    opts = %{
      color: opts[:color] || "info",
      class: opts[:class] || ""
    }

    base_classes = "flex items-center w-full gap-3 px-4 py-2 text-sm rounded focus:outline-none"
    color_css = get_color_classes(opts.color)
    custom_classes = opts.class

    [base_classes, color_css, custom_classes]
  end

  defp get_color_classes("info"),
    do: "text-info-800 bg-info-100 dark:bg-info-200 dark:text-info-800"

  defp get_color_classes("success"),
    do: "text-success-800 bg-success-100 dark:bg-success-200 dark:text-success-800"

  defp get_color_classes("warning"),
    do: "text-warning-800 bg-warning-100 dark:bg-warning-200 dark:text-warning-800"

  defp get_color_classes("danger"),
    do: "text-danger-800 bg-danger-100 dark:bg-danger-200 dark:text-danger-800"

  defp get_dismiss_icon_classes("info"),
    do: "bg-info-100 dark:bg-info-200 hover:bg-info-200 dark:hover:bg-info-300 hover:text-info-800 dark:hover:text-info-900"

  defp get_dismiss_icon_classes("success"),
    do: "bg-success-100 dark:bg-success-200 hover:bg-success-200 dark:hover:bg-success-300 hover:text-success-800 dark:hover:text-success-900"

  defp get_dismiss_icon_classes("warning"),
    do: "bg-warning-100 dark:bg-warning-200 hover:bg-warning-200 dark:hover:bg-warning-300 hover:text-warning-800 dark:hover:text-warning-900"

  defp get_dismiss_icon_classes("danger"),
    do: "bg-danger-100 dark:bg-danger-200 hover:bg-danger-200 dark:hover:bg-danger-300 hover:text-danger-800 dark:hover:text-danger-900"

  defp get_icon(%{color: "info"} = assigns) do
    ~H"""
    <Heroicons.information_circle />
    """
  end

  defp get_icon(%{color: "success"} = assigns) do
    ~H"""
    <Heroicons.check_circle />
    """
  end

  defp get_icon(%{color: "warning"} = assigns) do
    ~H"""
    <Heroicons.exclamation_circle />
    """
  end

  defp get_icon(%{color: "danger"} = assigns) do
    ~H"""
    <Heroicons.x_circle />
    """
  end

  defp label_blank?(label, inner_block) do
    (!label || label == "") && inner_block == []
  end
end
