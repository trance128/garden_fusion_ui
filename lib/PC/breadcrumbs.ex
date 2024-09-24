defmodule PC.Breadcrumbs do
  use Phoenix.Component
  alias PC.{Icon, Link}

  attr(:separator, :string, default: "slash", values: ["slash", "chevron"])
  attr(:class, :string, default: "", doc: "Parent div CSS class")
  attr(:separator_class, :string, default: "", doc: "Separator div CSS class")
  attr(:link_class, :string, default: "", doc: "Link class CSS")
  attr(:links, :list, default: [], doc: "List of your links")
  attr(:rest, :global)

  # Example:
  # <.breadcrumbs separator="chevron"
  #   class="mt-3"
  #   link_class="!text-blue-500 text-sm font-semibold"
  #   links={[
  #     %{ label: "Link 1", to: "/" },
  #     %{ to: "/", icon: :home, icon_class="text-blue-500" },
  #     %{ label: "Link 1", to: "/", link_type: "patch|a|redirect" }
  #   ]}
  # />
  def breadcrumbs(assigns) do
    ~H"""
    <div {@rest} class={["flex items-center", @class]}>
      <%= for {link, counter} <- Enum.with_index(@links) do %>
        <%= if counter > 0 do %>
          <.separator type={@separator} class={@separator_class} />
        <% end %>

        <Link.a
          link_type={link[:link_type] || "a"}
          to={link.to}
          class={["flex text-gray-500 hover:underline dark:text-gray-400", @link_class]}
        >
          <div class="flex items-center gap-2">
            <%= if link[:icon] do %>
              <Icon.icon name={link[:icon]} class={["w-6 h-6 shrink-0", link[:icon_class]]} />
            <% end %>
            <%= if link[:label] do %>
              <%= link.label %>
            <% end %>
          </div>
        </Link.a>
      <% end %>
    </div>
    """
  end

  defp separator(%{type: "slash"} = assigns) do
    ~H"""
    <div class={["px-5 text-lg text-gray-300", @class]}>/</div>
    """
  end

  defp separator(%{type: "chevron"} = assigns) do
    ~H"""
    <div class={["px-3 text-gray-300", @class]}>
      <Heroicons.chevron_right solid class="w-6 h-6" />
    </div>
    """
  end
end
