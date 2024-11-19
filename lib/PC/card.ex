defmodule PC.Card do
  use Phoenix.Component
  import PC.Avatar
  import PC.Typography

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:variant, :string, default: "basic", values: ["basic", "outline"])
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def card(assigns) do
    ~H"""
    <div
      {@rest}
      class={[
        "flex flex-wrap overflow-hidden bg-card rounded-xl border border-border",
        @class
      ]}>
      <div class="flex flex-col w-full max-w-full">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  attr(:aspect_ratio_class, :any, default: "aspect-video", doc: "aspect ratio class")
  attr(:src, :string, default: nil, doc: "hosted image URL")
  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def card_media(assigns) do
    ~H"""
    <%= if @src do %>
      <img {@rest} src={@src} class={["flex-shrink-0 object-cover w-full", @aspect_ratio_class, @class]} />
    <% else %>
      <div {@rest} class={["flex-shrink-0 w-full bg-card ", @aspect_ratio_class, @class]}></div>
    <% end %>
    """
  end

  attr(:heading, :string, default: nil, doc: "creates a heading")
  attr(:category, :string, default: nil, doc: "creates a category")

  attr(:category_color_class, :any,
    default: "text-primary-600 dark:text-primary-400",
    doc: "sets a category color class"
  )

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def card_content(assigns) do
    ~H"""
    <div {@rest} class={["flex-1 p-6 text-base font-light text-gray-500 dark:text-gray-400", @class]}>
      <div :if={@category} class={["mb-3 text-sm font-medium", @category_color_class]}>
        <%= @category %>
      </div>

      <div :if={@heading} class="mb-2 text-xl font-medium text-gray-900 dark:text-gray-300">
        <%= @heading %>
      </div>

      <%= render_slot(@inner_block) || @label %>
    </div>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def card_footer(assigns) do
    ~H"""
    <div {@rest} class={["px-6 pb-6", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr(:name, :string, required: true, doc: "The reviewer's name")
  attr(:username, :string, required: true, doc: "The reviewer's username")
  attr(:img, :string, required: true, doc: "URL of the reviewer's avatar")
  attr(:body, :string, required: true, doc: "The review text content")
  attr(:class, :string, default: "", doc: "Additional classes")
  attr(:rest, :global)

  def review_card(assigns) do
    ~H"""
    <figure class={["relative md:w-64 cursor-pointer overflow-hidden rounded-xl border p-4    border-black/10 bg-black/[0.01] hover:bg-black/[0.05]    dark:border-white/10 dark:bg-white/10 dark:hover:bg-white/[0.15]", @class]} {@rest}>
      <div class="flex items-center gap-2">
        <.avatar src={@img} alt={@name} size="md" />
        <div class="flex flex-col">
          <figcaption>
            <.p no_margin class="text-sm pc-review-name"><%= @name %></.p>
          </figcaption>
          <p class="text-xs text-black/40 dark:text-white/40"><%= @username %></p>
        </div>
      </div>
      <blockquote class="mt-2">
        <.p class="text-sm" no_margin><%= @body %></.p>
      </blockquote>
    </figure>
    """
  end
end
