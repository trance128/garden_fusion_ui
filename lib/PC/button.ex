defmodule PC.Button do
  use Phoenix.Component

  alias PC.Loading
  alias PC.Link
  alias PC.Icon

  require Logger

  attr :size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"], doc: "button sizes"

  attr :variant, :string,
    default: "solid",
    values: ["solid", "outline", "inverted", "shadow"],
    doc: "button variant"

  attr :color, :string,
    default: "primary",
    values: [
      "primary",
      "secondary",
      "info",
      "success",
      "warning",
      "danger",
      "gray",
      "pure_white",
      "white",
      "light",
      "dark"
    ],
    doc: "button color"

  attr :to, :string, default: nil, doc: "link path"
  attr :loading, :boolean, default: false, doc: "indicates a loading state"
  attr :disabled, :boolean, default: false, doc: "indicates a disabled state"
  attr :icon, :atom, default: nil, doc: "name of a Heroicon at the front of the button"
  attr :with_icon, :boolean, default: false, doc: "adds some icon base classes"

  attr :link_type, :string,
    default: "button",
    values: ["a", "live_patch", "live_redirect", "button"]

  attr :class, :string, default: "", doc: "CSS class"
  attr :label, :string, default: nil, doc: "labels your button"

  attr :rest, :global,
    include: ~w(method download hreflang ping referrerpolicy rel target type value name form)

  slot :inner_block, required: false

  def button(assigns) do
    assigns =
      assigns
      |> assign(:classes, button_classes(assigns))

    ~H"""
    <Link.a to={@to} link_type={@link_type} class={@classes} disabled={@disabled} {@rest}>
      <%= if @loading do %>
        <Loading.spinner show={true} size_class={"animate-spin--#{@size}"} />
      <% else %>
        <%= if @icon do %>
          <Icon.icon name={@icon} mini class={"animate-spin--#{@size}"} />
        <% end %>
      <% end %>

      <%= render_slot(@inner_block) || @label %>
    </Link.a>
    """
  end

  attr :size, :string, default: "sm", values: ["xs", "sm", "md", "lg", "xl"]

  attr :color, :string,
    default: "gray",
    values: [
      "primary",
      "secondary",
      "info",
      "success",
      "warning",
      "danger",
      "gray"
    ]

  attr :to, :string, default: nil, doc: "link path"
  attr :loading, :boolean, default: false, doc: "indicates a loading state"
  attr :disabled, :boolean, default: false, doc: "indicates a disabled state"
  attr :with_icon, :boolean, default: false, doc: "adds some icon base classes"

  attr :link_type, :string,
    default: "button",
    values: ["a", "live_patch", "live_redirect", "button"]

  attr :class, :string, default: "", doc: "CSS class"
  attr :tooltip, :string, default: nil, doc: "tooltip text"

  attr :rest, :global,
    include: ~w(method download hreflang ping referrerpolicy rel target type value name form)

  slot :inner_block, required: false

  def icon_button(assigns) do
    ~H"""
    <Link.a
      to={@to}
      link_type={@link_type}
      class={[
        "inline-block p-2 rounded-full",
        @disabled && "opacity-50 cursor-not-allowed",
        "inline-block p-2 rounded-full-bg--#{@color}",
        "inline-block p-2 rounded-full--#{@color}",
        "inline-block p-2 rounded-full--#{@size}",
        @class
      ]}
      disabled={@disabled}
      {@rest}
    >
      <div class={@tooltip && "relative group/inline-block p-2 rounded-full flex flex-col items-center"}>
        <%= if @loading do %>
          <Loading.spinner show={true} size_class={"inline-block p-2 rounded-full-spinner--#{@size}"} />
        <% else %>
          <%= render_slot(@inner_block) %>

          <div :if={@tooltip} role="tooltip" class="absolute flex-col items-center invisible mb-6 transition-opacity duration-300 -translate-y-full opacity-0 -top-1 group-hover/inline-block p-2 rounded-full:flex group-hover/inline-block p-2 rounded-full:visible group-hover/inline-block p-2 rounded-full:opacity-100">
            <span class="relative z-10 p-2 text-xs leading-none text-white bg-gray-900 rounded-sm shadow-lg whitespace-nowrap dark:bg-gray-700">
              <%= @tooltip %>
            </span>
            <div class="w-3 h-3 -mt-2 rotate-45 bg-gray-900 dark:bg-gray-700"></div>
          </div>
        <% end %>
      </div>
    </Link.a>
    """
  end

  defp button_classes(opts) do
    opts = %{
      size: opts[:size] || "md",
      variant: opts[:variant] || "solid",
      color: opts[:color] || "primary",
      loading: opts[:loading] || false,
      disabled: opts[:disabled] || false,
      with_icon: opts[:with_icon] || opts[:icon] || false,
      user_added_classes: opts[:class] || ""
    }

    [
      "inline-flex items-center justify-center font-medium transition duration-150 ease-in-out border rounded-md focus:outline-none",
      "inline-flex items-center justify-center font-medium transition duration-150 ease-in-out border rounded-md focus:outline-none--#{String.replace(opts.color, "_", "-")}#{if opts.variant == "solid", do: "", else: "-#{opts.variant}"}",
      "inline-flex items-center justify-center font-medium transition duration-150 ease-in-out border rounded-md focus:outline-none--#{opts.size}",
      opts.user_added_classes,
      opts.loading && "flex items-center gap-2 cursor-not-allowed whitespace-nowrap",
      opts.disabled && "opacity-50 cursor-not-allowed",
      opts.with_icon && "flex items-center gap-2 whitespace-nowrap"
    ]
  end
end
