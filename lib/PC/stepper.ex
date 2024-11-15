defmodule PC.Stepper do
  use Phoenix.Component
  import PC.Icon

  attr :steps, :list, required: true
  attr :orientation, :string, default: "horizontal", values: ["horizontal", "vertical"]
  attr :size, :string, default: "md", values: ["sm", "md", "lg"]
  attr :class, :string, default: ""

  def stepper(assigns) do
    ~H"""
    <div
      class={[
        "w-full",
        "w-full--#{@orientation}",
        "w-full--#{@size}",
        @class
      ]}
      role="list"
      aria-label="Progress steps"
    >
      <div class="flex md:gap-4">
        <%= for {step, index} <- Enum.with_index(@steps) do %>
          <!-- Step Item -->
          <div class="flex-shrink-0" role="listitem">
            <button
              type="button"
              class="flex items-center gap-4 focus:outline-none ring-0"
              id={"step-#{index}"}
              phx-click={step[:on_click]}
              aria-current={step.active? && "step"}
              aria-label={"Step #{index + 1}: #{step.name}#{if step.complete?, do: " (completed)"}"}
            >
              <!-- Node -->
              <div class={[
                "flex items-center gap-4 transition-all duration-200 cursor-pointer hover:opacity-90",
                step.complete? && "flex items-center gap-4 transition-all duration-200 cursor-pointer hover:opacity-90--complete",
                step.active? && "flex items-center gap-4 transition-all duration-200 cursor-pointer hover:opacity-90--active"
              ]}>
                <div class="grid flex-shrink-0 text-white transition-all duration-200 bg-gray-500 rounded-full place-items-center" aria-hidden="true">
                  <%= if step.complete? do %>
                    <.icon name="hero-check-solid" class="text-white" />
                  <% else %>
                    <span class="font-semibold">
                      <%= index + 1 %>
                    </span>
                  <% end %>
                </div>
              </div>
              <!-- Content -->
              <div class="flex flex-col w-full gap-1 text-left grow">
                <h3 class="text-sm font-semibold text-gray-900 dark:text-gray-100" id={"step-title-#{index}"}>
                  <%= step.name %>
                </h3>
                <%= if Map.get(step, :description) do %>
                  <p class="text-sm text-gray-500 dark:text-gray-400" id={"step-description-#{index}"}>
                    <%= step.description %>
                  </p>
                <% end %>
              </div>
            </button>
          </div>

          <%= if index < length(@steps) - 1 do %>
            <div class="flex self-start shrink md:self-center" aria-hidden="true">
              <div class={[
                "bg-gray-200 shrink dark:bg-gray-600",
                step.complete? && Enum.at(@steps, index + 1).complete? &&
                  "bg-success-500 dark:bg-success-500"
              ]} />
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
