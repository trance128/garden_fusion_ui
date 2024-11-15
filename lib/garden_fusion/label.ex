defmodule GardenFusion.Label do
  use Phoenix.Component

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :any, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class={[
        "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70",
        @class
      ]}>
      <%= render_slot(@inner_block) %>
    </label>
    """
  end
end
