defmodule PC.Modal do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr :id, :string, default: "modal", doc: "modal id"
  attr :hide, :boolean, default: false, doc: "modal is hidden"
  attr :title, :string, default: nil, doc: "modal title"
  attr :class, :string, default: nil, doc: "modal class"

  attr :close_modal_target, :string,
    default: nil,
    doc:
      "close_modal_target allows you to target a specific live component for the close event to go to. eg: close_modal_target={@myself}"

  attr :close_on_click_away, :boolean,
    default: true,
    doc: "whether the modal should close when a user clicks away"

  attr :close_on_escape, :boolean,
    default: true,
    doc: "whether the modal should close when a user hits escape"

  attr :hide_close_button, :boolean,
    default: false,
    doc: "whether or not the modal should have a close button in the header"

  attr :on_cancel, JS,
    default: JS.exec("data-cancel-default"),
    doc:
      "a JS function to execute when the modal is closed. Defaults to pushing close_modal event"

  attr :max_width, :string,
    default: "md",
    values: ["sm", "md", "lg", "xl", "2xl", "full"],
    doc: "modal max width"

  attr :rest, :global
  slot :inner_block, required: false

  def modal(assigns) do
    assigns =
      assigns
      |> assign(:classes, get_classes(assigns))

    ~H"""
    <div
      id={@id}
      phx-mounted={!@hide && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      data-cancel-default={push_close_modal_event(@close_modal_target)}
      {@rest}
      class="hidden relative z-50"
    >
      <div class="fixed inset-0 z-50 transition-opacity bg-gray-50/90 dark:bg-gray-900/90" aria-hidden="true"></div>
      <div class="fixed inset-0 z-50 flex items-center justify-center px-4 my-4 overflow-hidden transform sm:px-6" role="dialog" aria-modal="true">
        <div
          class={@classes}
          phx-click-away={@close_on_click_away && JS.exec("data-cancel", to: "##{@id}")}
          phx-window-keydown={@close_on_escape && JS.exec("data-cancel", to: "##{@id}")}
          phx-key="escape"
        >
          <!-- Header -->
          <div class="px-5 py-3 border-b border-gray-100 dark:border-gray-700">
            <div class="flex items-center justify-between">
              <div class="font-semibold text-gray-800 dark:text-gray-200">
                <%= @title %>
              </div>
              <%= unless @hide_close_button do %>
                <button
                  type="button"
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  class="text-gray-400 hover:text-gray-500"
                >
                  <div class="sr-only">Close</div>
                  <Heroicons.x_mark class="w-5 h-5 fill-current" />
                </button>
              <% end %>
            </div>
          </div>
          <!-- Content -->
          <div class="p-5">
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # The live view that calls <.modal> will need to handle the "close_modal" event. eg:
  # def handle_event("close_modal", _, socket) do
  #   {:noreply, push_patch(socket, to: Routes.moderate_users_path(socket, :index))}
  # end
  defp push_close_modal_event(close_modal_target) do
    if close_modal_target do
      JS.push(%JS{}, "close_modal", target: close_modal_target)
    else
      JS.push(%JS{}, "close_modal")
    end
  end

  def hide_modal(id \\ "modal") do
    %JS{}
    |> JS.hide(
      to: "##{id} .fixed inset-0 z-50 transition-opacity bg-gray-50/90 dark:bg-gray-900/90",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> JS.hide(
      to: "##{id} .w-full max-h-full overflow-auto bg-white shadow-lg rounded-xl dark:bg-gray-800",
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  # We are unsure of what the best practice is for using this.
  # Open to suggestions/PRs
  def show_modal(js \\ %JS{}, id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id} .fixed inset-0 z-50 transition-opacity bg-gray-50/90 dark:bg-gray-900/90",
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> JS.show(
      to: "##{id} .w-full max-h-full overflow-auto bg-white shadow-lg rounded-xl dark:bg-gray-800",
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id} .w-full max-h-full overflow-auto bg-white shadow-lg rounded-xl dark:bg-gray-800")
  end

  defp get_classes(assigns) do
    opts = %{
      max_width: assigns[:max_width] || "md",
      class: assigns[:class] || ""
    }

    base_classes = "w-full max-h-full overflow-auto bg-white shadow-lg rounded-xl dark:bg-gray-800"
    max_width_class = "w-full max-h-full overflow-auto bg-white shadow-lg rounded-xl dark:bg-gray-800--#{opts.max_width}"
    custom_classes = opts.class

    [max_width_class, base_classes, custom_classes]
  end
end
