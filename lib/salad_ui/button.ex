defmodule SaladUI.Button do
  @moduledoc false
  use SaladUI, :component

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr(:type, :string, default: nil)
  attr(:class, :any, default: nil)

  attr(:variant, :string,
    values: ~w(default secondary destructive outline ghost link),
    default: "default",
    doc: "the button variant style"
  )

  attr(:size, :string, values: ~w(default sm lg icon icon_large xs_round_icon s_round_icon m_round_icon l_round_icon xl_round_icon xxl_round_icon), default: "default")
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def(button(assigns)) do
    assigns = assign(assigns, :variant_class, variant(assigns))

    ~H"""
    <button
      type={@type}
      class={
        [
          "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
          @variant_class,
          @class
        ]
      }
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :text, :string, required: true
  attr :color, :string, default: "bg-primary"
  attr :text_color, :string, default: "text-primary-foreground"
  attr :class, :string, default: ""
  attr :overlay_class, :string, default: ""
  attr(:type, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value phx-click))
  def button_dynamic_color(assigns) do
    ~H"""
    <div class="relative group">
      <.button
          class={@class}
          style={"background-color: #{@color};"}
          aria-label={"Button for #{@text}"}
          type={@type}
          {@rest}
      >
        <%= @text %>
      </.button>

      <div class={[
          "pointer-events-none",
          "absolute inset-0 bg-black opacity-0 group-hover:opacity-30 rounded-md transition duration-200 ease-in-out",
          "flex items-center justify-center #{@text_color} font-medium",
          @overlay_class
      ]}>
          <%= @text %>
      </div>
    </div>
    """
  end

  attr :text, :string, required: true
  attr :class, :string, default: ""
  attr :style, :string, default: nil
  attr(:type, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))
  def default_button(assigns) do
    ~H"""
    <.button aria-label={"Button for #{@text}"}
        style={@style}
        class={@class}
        type={@type}
        {@rest}
    >
      <%= @text %>
    </.button>
    """
  end

  @variants %{
    variant: %{
      "default" => "bg-primary text-primary-foreground shadow hover:bg-primary/90",
      "destructive" => "bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",
      "outline" => "border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",
      "secondary" => "bg-secondary-button text-secondary-button-foreground shadow-sm hover:bg-secondary-button/80",
      "ghost" => "hover:bg-accent hover:text-accent-foreground",
      "link" => "text-primary underline-offset-4 hover:underline"
    },
    size: %{
      "default" => "h-9 px-4 py-2",
      "sm" => "h-8 rounded-md px-3 text-xs",
      "lg" => "h-10 rounded-md px-8",
      "icon" => "h-9 w-9",
      "icon_large" => "h-12 w-12",
      "xs_round_icon" => "rounded-full h-4 w-4",
      "s_round_icon" => "rounded-full h-6 w-6",
      "m_round_icon" => "rounded-full h-10 w-10",
      "l_round_icon" => "rounded-full h-12 w-12",
      "xl_round_icon" => "rounded-full h-20 w-20",
      "xxl_round_icon" => "rounded-full h-24 w-24"
    }
  }

  @default_variants %{
    variant: "default",
    size: "default"
  }

  defp variant(props) do
    variants = Map.take(props, ~w(variant size)a)
    variants = Map.merge(@default_variants, variants)

    Enum.map_join(variants, " ", fn {key, value} -> @variants[key][value] end)
  end
end
