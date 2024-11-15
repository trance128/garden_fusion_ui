defmodule SaladUI.Slider do
  @moduledoc false
  use SaladUI, :component

  @doc """
  Render Slider range input

  ## Example


      <.slider class="w-[60%]" id="slider-single-default-slider" max={50} min={10} step={5} value={20}/>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:value, :integer, default: 0, doc: "")
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 100)
  attr(:step, :integer, default: 1)
  attr(:rest, :global)

  def slider(assigns) do
    assigns =
      assigns
      |> Map.put(:value, normalize_integer(assigns[:value]))
      |> Map.put(:min, normalize_integer(assigns[:min]))
      |> Map.put(:max, normalize_integer(assigns[:max]))
      |> Map.put(:step, normalize_integer(assigns[:step]))

    ~H"""
    <div
      class={["relative w-full", @class]}
      style={"--#{@id}-val: #{(@value - @min)/(@max - @min) * 100}"}
    >
      <span class={["relative flex w-full touch-none select-none items-center"]}>
        <span
          data-orientation="horizontal"
          class="relative h-2 w-full grow overflow-hidden rounded-full bg-secondary"
        >
          <span
            data-orientation="horizontal"
            class="absolute h-full bg-primary"
            style={"left: 0%; right: calc(100% - var(--#{@id}-val)*1%)"}
          >
          </span>
        </span>
        <span style={"transform: translateX(-50%); position: absolute; left: calc(var(--#{@id}-val)*1%);"}>
          <span
            role="slider"
            aria-valuemin={@min}
            aria-valuemax={@max}
            aria-orientation="horizontal"
            data-orientation="horizontal"
            tabindex="0"
            class="block h-5 w-5 rounded-full border-2 border-primary bg-background ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50"
          >
          </span>
        </span>
      </span>
      <input
        type="range"
        class="absolute top-0 -left-2 z-1 w-full appearance-none cursor-pointer opacity-0"
        min={@min}
        max={@max}
        value={@value}
        step={@step}
        id={@id}
        phx-update="ignore"
        style="width: calc(100% + 20px)"
        oninput={"this.parentNode.style='--#{@id}-val:' + (this.value - #{@min})/#{@max - @min}*100"}
        {@rest}
      />
    </div>
    """
  end
end
