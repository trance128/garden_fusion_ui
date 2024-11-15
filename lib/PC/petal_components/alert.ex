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
                class={["flex p-2 hover:cursor-pointer hover:rounded", get_dismiss_icon_classes(@color, @variant)]}
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
    color_css = get_color_classes(opts.color, opts.variant)
    custom_classes = opts.class

    [base_classes, color_css, custom_classes]
  end

  defp get_color_classes(color, variant) do
    "w-full grow-0--#{color}-#{variant}"
  end

  defp get_dismiss_icon_classes(color, variant) do
    "flex p-2 hover:cursor-pointer hover:rounded--#{color}-#{variant}"
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
