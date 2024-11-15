defmodule GardenFusion.Components.Animations do
  use     Phoenix.Component
  alias   Phoenix.LiveView.JS

  attr :id,     :string,  required: true
  attr :class,  :string,  default: nil
  attr :delay,  :integer, default: 0

  slot :inner_block,      required: true
  def fade_in(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={ js_fade_in() }
      class={[
        "hidden transition-all duration-300 transform opacity-0",
        @class
      ]}
      style={"transition-delay: #{@delay}ms;"}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp js_fade_in do
    JS.show(transition: {"ease-in ", "opacity-0", "opacity-100"}, time: 0)
  end
end
