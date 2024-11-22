defmodule PC.Alert do
  use Phoenix.Component
  alias PC.Helpers
  import PC.Icon

  attr(:color, :string,
    default: "info",
    values: ["info", "success", "warning", "danger"]
  )

  attr(:variant, :string,
    default: "light",
    values: ["light", "soft", "dark", "outline"],
    doc: "The variant of the alert"
  )

  attr(:with_icon, :boolean, default: false, doc: "adds some icon base classes")
  attr(:class, :any, default: nil, doc: "CSS class for parent div")
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
      |> assign(:heading_id, Helpers.uniq_id(assigns.heading || "alert-heading"))
      |> assign(:label_id, Helpers.uniq_id(assigns.label || "alert-label"))

    ~H"""
    <%= unless label_blank?(@label, @inner_block) do %>
      <div
        {@rest}
        class={@classes}
        role="dialog"
        aria-labelledby={(@heading && @heading_id) || @label_id}
        aria-describedby={@label_id}
      >
        <%= if @with_icon do %>
          <div class="self-start flex-shrink-0 pt-0.5 w-6 h-6">
            <.get_icon color={@color} />
          </div>
        <% end %>

        <div class="w-full grow-0">
          <div class="flex items-start justify-between">
            <div>
              <%= if @heading do %>
                <h2 id={@heading_id} class="pt-1 font-bold">
                  <%= @heading %>
                </h2>
              <% end %>

              <div id={@label_id} class="py-1 font-medium">
                <%= render_slot(@inner_block) || @label %>
              </div>
            </div>

            <%= if @close_button_properties do %>
              <button
                class={["flex p-2 hover:cursor-pointer hover:rounded", "flex p-2 hover:cursor-pointer", get_dismiss_icon_classes(@color, @variant)]}
                {@close_button_properties}
              >
                <.icon name="hero-x-mark-solid" class="self-start w-4 h-4" />
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
      variant: opts[:variant] || "light",
      class: opts[:class] || ""
    }

    base_classes = "flex items-center w-full gap-3 px-4 py-2 text-sm rounded focus:outline-none"
    color_css = "w-full grow-0" <> get_color_classes(opts.color, opts.variant)
    custom_classes = opts.class

    [base_classes, color_css, custom_classes]
  end

  # Color variant functions
  defp get_color_classes("info", "light") do
    "text-info-800 bg-info-100 dark:bg-info-200 dark:text-info-800"
  end

  defp get_color_classes("info", "soft") do
    "text-info-800 bg-info-100 dark:bg-info-900 dark:text-info-300 dark:border dark:border-info-800"
  end

  defp get_color_classes("info", "dark") do
    "text-white bg-info-600"
  end

  defp get_color_classes("info", "outline") do
    "bg-white border text-info-600 dark:bg-transparent border-info-600 dark:text-info-400 dark:border-info-400"
  end

  defp get_color_classes("success", "light") do
    "text-success-800 bg-success-100 dark:bg-success-200 dark:text-success-800"
  end

  defp get_color_classes("success", "soft") do
    "text-success-800 bg-success-100 dark:bg-success-900 dark:text-success-300 dark:border dark:border-success-800"
  end

  defp get_color_classes("success", "dark") do
    "text-white bg-success-600"
  end

  defp get_color_classes("success", "outline") do
    "bg-white border text-success-600 dark:bg-transparent border-success-600 dark:text-success-400 dark:border-success-400"
  end

  defp get_color_classes("warning", "light") do
    "text-warning-800 bg-warning-100 dark:bg-warning-200 dark:text-warning-800"
  end

  defp get_color_classes("warning", "soft") do
    "text-warning-800 bg-warning-100 dark:bg-warning-900 dark:text-warning-300 dark:border dark:border-warning-800"
  end

  defp get_color_classes("warning", "dark") do
    "text-white bg-warning-600"
  end

  defp get_color_classes("warning", "outline") do
    "bg-white border text-warning-600 dark:bg-transparent border-warning-600 dark:text-warning-400 dark:border-warning-400"
  end

  defp get_color_classes("danger", "light") do
    "text-danger-800 bg-danger-100 dark:bg-danger-200 dark:text-danger-800"
  end

  defp get_color_classes("danger", "soft") do
    "text-danger-800 bg-danger-100 dark:bg-danger-900 dark:text-danger-300 dark:border dark:border-danger-800"
  end

  defp get_color_classes("danger", "dark") do
    "text-white bg-danger-600"
  end

  defp get_color_classes("danger", "outline") do
    "bg-white border text-danger-600 dark:bg-transparent border-danger-600 dark:text-danger-400 dark:border-danger-400"
  end

  # Dismiss button variant functions
  defp get_dismiss_icon_classes("info", "light") do
    "bg-info-100 dark:bg-info-200 hover:bg-info-200 dark:hover:bg-info-300 hover:text-info-800 dark:hover:text-info-800"
  end

  defp get_dismiss_icon_classes("info", "soft") do
    "bg-info-100 dark:bg-info-900 hover:bg-info-200 dark:hover:bg-info-800 hover:text-info-800 dark:hover:text-info-200"
  end

  defp get_dismiss_icon_classes("info", "dark") do
    "text-white bg-info-600 hover:bg-info-500"
  end

  defp get_dismiss_icon_classes("info", "outline") do
    "hover:bg-info-50 dark:hover:bg-gray-800 text-info-600 dark:text-info-400"
  end

  defp get_dismiss_icon_classes("success", "light") do
    "bg-success-100 dark:bg-success-200 hover:bg-success-200 dark:hover:bg-success-300 hover:text-success-800 dark:hover:text-success-800"
  end

  defp get_dismiss_icon_classes("success", "soft") do
    "bg-success-100 dark:bg-success-900 hover:bg-success-200 dark:hover:bg-success-800 hover:text-success-800 dark:hover:text-success-200"
  end

  defp get_dismiss_icon_classes("success", "dark") do
    "text-white bg-success-600 hover:bg-success-500"
  end

  defp get_dismiss_icon_classes("success", "outline") do
    "hover:bg-success-50 dark:hover:bg-gray-800 text-success-600 dark:text-success-400"
  end

  defp get_dismiss_icon_classes("warning", "light") do
    "bg-warning-100 dark:bg-warning-200 hover:bg-warning-200 dark:hover:bg-warning-300 hover:text-warning-800 dark:hover:text-warning-800"
  end

  defp get_dismiss_icon_classes("warning", "soft") do
    "bg-warning-100 dark:bg-warning-900 hover:bg-warning-200 dark:hover:bg-warning-800 hover:text-warning-800 dark:hover:text-warning-200"
  end

  defp get_dismiss_icon_classes("warning", "dark") do
    "text-white bg-warning-600 hover:bg-warning-500"
  end

  defp get_dismiss_icon_classes("warning", "outline") do
    "hover:bg-warning-50 dark:hover:bg-gray-800 text-warning-600 dark:text-warning-400"
  end

  defp get_dismiss_icon_classes("danger", "light") do
    "bg-danger-100 dark:bg-danger-200 hover:bg-danger-200 dark:hover:bg-danger-300 hover:text-danger-800 dark:hover:text-danger-800"
  end

  defp get_dismiss_icon_classes("danger", "soft") do
    "bg-danger-100 dark:bg-danger-900 hover:bg-danger-200 dark:hover:bg-danger-800 hover:text-danger-800 dark:hover:text-danger-200"
  end

  defp get_dismiss_icon_classes("danger", "dark") do
    "text-white bg-danger-600 hover:bg-danger-500"
  end

  defp get_dismiss_icon_classes("danger", "outline") do
    "hover:bg-danger-50 dark:hover:bg-gray-800 text-danger-600 dark:text-danger-400"
  end

  defp get_icon(%{color: "info"} = assigns) do
    ~H"""
    <.icon name="hero-information-circle" />
    """
  end

  defp get_icon(%{color: "success"} = assigns) do
    ~H"""
    <.icon name="hero-check-circle" />
    """
  end

  defp get_icon(%{color: "warning"} = assigns) do
    ~H"""
    <.icon name="hero-exclamation-circle" />
    """
  end

  defp get_icon(%{color: "danger"} = assigns) do
    ~H"""
    <.icon name="hero-x-circle" />
    """
  end

  defp label_blank?(label, inner_block) do
    (!label || label == "") && inner_block == []
  end
end
