defmodule PC.Badge do
  use Phoenix.Component

  attr(:size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"])
  attr(:variant, :string, default: "light", values: ["light", "dark", "outline"])

  attr(:color, :string,
    default: "primary",
    values: ["primary", "secondary", "info", "success", "warning", "danger", "gray"]
  )

  attr(:with_icon, :boolean, default: false, doc: "adds some icon base classes")
  attr(:class, :string, default: "", doc: "CSS class for parent div")
  attr(:label, :string, default: nil, doc: "label your badge")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def badge(assigns) do
    ~H"""
    <badge
      {@rest}
      class={[
        "inline-flex items-center justify-center border rounded focus:outline-none",
        "inline-flex items-center justify-center border rounded focus:outline-none--#{@size}",
        @with_icon && "flex items-center gap-1 whitespace-nowrap",
        "inline-flex items-center justify-center border rounded focus:outline-none--#{@color}-#{@variant}",
        @class
      ]}
    >
      <%= render_slot(@inner_block) || @label %>
    </badge>
    """
  end
end
