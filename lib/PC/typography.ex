defmodule PC.Typography do
  use Phoenix.Component

  @moduledoc """
  Everything related to text. Headings, paragraphs and links
  """

  # <.h1>Heading</.h1>
  # <.h1 label="Heading" />
  # <.h1 label="Heading" class="mb-10" color_class="text-blue-500" />

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "label your heading")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from headings")
  attr(:underline, :boolean, default: false, doc: "underlines a heading")
  attr(:color_class, :any, default: nil, doc: "adds a color class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def h1(assigns) do
    ~H"""
    <h1 class={get_heading_classes("text-4xl font-extrabold leading-10 sm:text-5xl sm:tracking-tight lg:text-6xl", @class, @color_class, @underline, @no_margin)} {@rest}>
      <%= render_slot(@inner_block) || @label %>
    </h1>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "label your heading")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from headings")
  attr(:underline, :boolean, default: false, doc: "underlines a heading")
  attr(:color_class, :any, default: nil, doc: "adds a color class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def h2(assigns) do
    ~H"""
    <h2 class={get_heading_classes("text-2xl font-extrabold leading-10 sm:text-3xl", @class, @color_class, @underline, @no_margin)} {@rest}>
      <%= render_slot(@inner_block) || @label %>
    </h2>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "label your heading")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from headings")
  attr(:underline, :boolean, default: false, doc: "underlines a heading")
  attr(:color_class, :any, default: nil, doc: "adds a color class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def h3(assigns) do
    ~H"""
    <h3 class={get_heading_classes("text-xl font-bold leading-7 sm:text-2xl", @class, @color_class, @underline, @no_margin)} {@rest}>
      <%= render_slot(@inner_block) || @label %>
    </h3>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "label your heading")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from headings")
  attr(:underline, :boolean, default: false, doc: "underlines a heading")
  attr(:color_class, :any, default: nil, doc: "adds a color class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def h4(assigns) do
    ~H"""
    <h4 class={get_heading_classes("text-lg font-bold leading-6", @class, @color_class, @underline, @no_margin)} {@rest}>
      <%= render_slot(@inner_block) || @label %>
    </h4>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:label, :string, default: nil, doc: "label your heading")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from headings")
  attr(:underline, :boolean, default: false, doc: "underlines a heading")
  attr(:color_class, :any, default: nil, doc: "adds a color class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def h5(assigns) do
    ~H"""
    <h5 class={get_heading_classes("text-lg font-medium leading-6", @class, @color_class, @underline, @no_margin)} {@rest}>
      <%= render_slot(@inner_block) || @label %>
    </h5>
    """
  end

  defp get_heading_classes(base_classes, custom_classes, color_class, underline, no_margin) do
    [
      base_classes,
      custom_classes,
      color_class || "text-gray-900 dark:text-white",
      underline && "pb-2 border-b border-gray-200",
      !no_margin && "mb-3"
    ]
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:no_margin, :boolean, default: nil, doc: "removes margin from paragraph")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def p(assigns) do
    ~H"""
    <p
      class={[
        "leading-5 text-gray-700 dark:text-gray-300",
        !@no_margin && "mb-2",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def prose(assigns) do
    ~H"""
    <div class={["prose dark:prose-invert", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Usage:
      <.ul>
        <li>Item 1</li>
        <li>Item 2</li>
      </.ul>
  """

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def ul(assigns) do
    ~H"""
    <ul class={["leading-5 text-gray-700 dark:text-gray-300", "list-disc list-inside", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </ul>
    """
  end

  @doc """
  Usage:
      <.ol>
        <li>Item 1</li>
        <li>Item 2</li>
      </.ol>
  """

  attr(:class, :any, default: nil, doc: "CSS class")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def ol(assigns) do
    ~H"""
    <ol class={["leading-5 text-gray-700 dark:text-gray-300", "list-decimal list-inside", @class]} {@rest}>
      <%= render_slot(@inner_block) %>
    </ol>
    """
  end
end
