defmodule AdhdAllyWeb.Components.AnimatedCard do
  use     Phoenix.Component

  import  GardenFusion.Components.Animations
  import  SaladUI.Card

  attr :id,     :string,  required: true
  attr :class,  :string,  default: ""
  attr :delay,  :integer, default: 0

  slot :inner_block,      required: true
  def animated_card(assigns) do
    ~H"""
    <.fade_in id={"fade-card-#{@id}"} delay={@delay}>
      <.card class={["text-sm p-4 text-sm flex", @class]}>
          <%= render_slot(@inner_block) %>
      </.card>
    </.fade_in>
    """
  end
end
