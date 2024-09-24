defmodule PC.Progress do
  use Phoenix.Component

  attr(:size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"])

  attr(:color, :string,
    default: "primary",
    values: ["primary", "secondary", "info", "success", "warning", "danger", "gray"]
  )

  attr(:label, :string, default: nil, doc: "labels your progress bar [xl only]")
  attr(:value, :integer, default: nil, doc: "adds a value to your progress bar")
  attr(:max, :integer, default: 100, doc: "sets a max value for your progress bar")
  attr(:class, :string, default: "", doc: "CSS class")
  attr(:rest, :global)

  def progress(assigns) do
    ~H"""
    <div {@rest} class={["flex overflow-hidden--#{@size}", "flex overflow-hidden", "flex overflow-hidden--#{@color}", @class]}>
      <span
        class={["flex flex-col justify-center--#{@color}", "flex flex-col justify-center"]}
        style={"width: #{Float.round(@value/@max*100, 2)}%"}
      >
        <%= if @size == "xl" do %>
          <span class="px-4 text-xs font-normal leading-6 text-center text-white whitespace-nowrap">
            <%= @label %>
          </span>
        <% end %>
      </span>
    </div>
    """
  end
end
