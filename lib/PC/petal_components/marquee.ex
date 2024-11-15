defmodule PC.Marquee do
  use Phoenix.Component

  attr(:pause_on_hover, :boolean,
    default: false,
    doc: "Pause the marquee when the user hovers over the cards"
  )

  attr(:repeat, :integer, default: 4, doc: "Number of times to repeat the content")
  attr(:vertical, :boolean, default: false, doc: "Display the marquee vertically")
  attr(:reverse, :boolean, default: false, doc: "Reverse the direction of the marquee")
  attr(:duration, :string, default: "30s", doc: "Animation duration")
  attr(:gap, :string, default: "1rem", doc: "Gap between items")
  attr(:overlay_gradient, :boolean, default: true, doc: "Add gradient overlay at edges")

  attr(:max_width, :string,
    default: "none",
    values: ["sm", "md", "lg", "xl", "2xl", "none"],
    doc: "Maximum width of the marquee container"
  )

  attr(:max_height, :string,
    default: "none",
    values: ["sm", "md", "lg", "xl", "2xl", "none"],
    doc: "Maximum height of the marquee container"
  )

  attr(:class, :string, default: "", doc: "CSS class for parent div")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def marquee(assigns) do
    ~H"""
    <div class="relative overflow-hidden">
      <div
        :if={@repeat > 0}
        class={[
          "relative flex p-2 overflow-hidden gap: var(--gap) group",
          @vertical && "pc-vertical",
          @class
        ]}
        max-width={@max_width}
        max-height={@max_height}
        style={"--duration: #{@duration}; --gap: #{@gap};"}
        {@rest}
      >
        <%= for _ <- 0..(@repeat - 1) do %>
          <div
            class={[
              "flex justify-around shrink-0 gap: var(--gap)",
              @vertical && "flex-col animation: marquee-vertical var(--duration) linear infinite",
              !@vertical && "flex-row animation: marquee var(--duration) linear infinite",
              @pause_on_hover && "group-hover:[animation-play-state:paused]"
            ]}
            style={@reverse && "animation-direction: reverse;"}
          >
            <%= render_slot(@inner_block) %>
          </div>
        <% end %>
      </div>

      <%= if @overlay_gradient do %>
        <%= if @vertical do %>
          <div class="absolute top-0 left-0 right-0 pointer-events-none h-1/3 bg-gradient-to-b from-white to-white/0 dark:from-gray-900 dark:to-gray-900/0"></div>
          <div class="absolute bottom-0 left-0 right-0 pointer-events-none h-1/3 bg-gradient-to-t from-white to-white/0 dark:from-gray-900 dark:to-gray-900/0"></div>
        <% else %>
          <div class="absolute top-0 bottom-0 left-0 w-1/3 pointer-events-none bg-gradient-to-r from-white to-white/0 dark:from-gray-900 dark:to-gray-900/0"></div>
          <div class="absolute top-0 bottom-0 right-0 w-1/3 pointer-events-none bg-gradient-to-r from-white/0 to-white dark:from-gray-900/0 dark:to-gray-900"></div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
