defmodule PC.Tabs do
  use Phoenix.Component

  alias PC.Link

  attr(:underline, :boolean, default: false, doc: "underlines your tabs")
  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def tabs(assigns) do
    ~H"""
    <nav {@rest} class={["flex gap-x-8 gap-y-2", @underline && "flex gap-x-8 gap-y-2--underline", @class]} role="tablist">
      <%= render_slot(@inner_block) %>
    </nav>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "labels your tab")

  attr(:link_type, :string,
    default: "a",
    values: ["a", "live_patch", "live_redirect"]
  )

  attr(:to, :string, default: nil, doc: "link path")
  attr(:number, :integer, default: nil, doc: "indicates a number next to your tab")
  attr(:underline, :boolean, default: false, doc: "underlines your tab")
  attr(:is_active, :boolean, default: false, doc: "indicates the current tab")
  attr(:disabled, :boolean, default: false, doc: "disables your tab")
  attr(:rest, :global, include: ~w(method download hreflang ping referrerpolicy rel target type))
  slot(:inner_block, required: false)

  def tab(assigns) do
    ~H"""
    <Link.a
      link_type={@link_type}
      label={@label}
      to={@to}
      class={get_tab_class(@is_active, @underline) ++ [@class]}
      disabled={@disabled}
      role="tab"
      aria-selected={@is_active}
      {@rest}
    >
      <%= if @number do %>
        <%= render_slot(@inner_block) || @label %>

        <span class={get_tab_number_class(@is_active, @underline)}>
          <%= @number %>
        </span>
      <% else %>
        <%= render_slot(@inner_block) || @label %>
      <% end %>
    </Link.a>
    """
  end

  # Pill CSS
  defp get_tab_class(is_active, false) do
    base_classes = "flex items-center px-3 py-2 text-sm font-medium rounded-md whitespace-nowrap"

    active_classes =
      if is_active,
        do: "bg-primary-100 dark:bg-gray-800 text-primary-600 dark:text-primary-500",
        else: "text-gray-500 hover:text-gray-600 dark:hover:text-gray-300 dark:text-gray-400 dark:hover:bg-gray-800 hover:bg-gray-100"

    [base_classes, active_classes]
  end

  # Underline CSS
  defp get_tab_class(is_active, underline) do
    base_classes = "flex items-center px-3 py-3 text-sm font-medium border-b-2 whitespace-nowrap"

    active_classes =
      if is_active,
        do: "border-primary-500 text-primary-600 dark:text-primary-500 dark:border-primary-500",
        else: "text-gray-500 border-transparent dark:hover:text-gray-300 dark:text-gray-400 hover:border-gray-300 hover:text-gray-600"

    underline_classes =
      if is_active && underline,
        do: "flex items-center px-3 py-3 text-sm font-medium border-b-2 whitespace-nowrap--with-underline-and-is-active",
        else: "hover:border-gray-300"

    [base_classes, active_classes, underline_classes]
  end

  # Underline
  defp get_tab_number_class(is_active, true) do
    base_classes = "whitespace-nowrap ml-2 py-0.5 px-2 rounded-full text-xs font-normal"

    active_classes =
      if is_active,
        do: "bg-primary-100 text-primary-600",
        else: "text-gray-500 bg-gray-100"

    underline_classes =
      if is_active,
        do: "bg-primary-100 dark:bg-primary-600 text-primary-600 dark:text-white",
        else: "text-gray-500 bg-gray-100 dark:bg-gray-600 dark:text-white"

    [base_classes, active_classes, underline_classes]
  end

  # Pill
  defp get_tab_number_class(is_active, false) do
    base_classes = "whitespace-nowrap ml-2 py-0.5 px-2 rounded-full text-xs font-normal"

    active_classes =
      if is_active,
        do: "text-white bg-primary-600",
        else: "text-white bg-gray-500 dark:bg-gray-600"

    [base_classes, active_classes]
  end
end
