defmodule PC.Accordion do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  attr(:container_id, :string)
  attr(:class, :any, default: "", doc: "CSS class for parent container")
  attr(:entries, :list, default: [%{}])

  attr(:js_lib, :string,
    default: "alpine_js",
    values: ["alpine_js", "live_view_js"],
    doc: "javascript library used for toggling"
  )

  attr(:rest, :global)

  slot :item, required: true, doc: "CSS class for parent container" do
    attr(:heading, :string)
  end

  def accordion(assigns) do
    assigns =
      assigns
      |> assign_new(:container_id, fn -> "accordion_#{Ecto.UUID.generate()}" end)

    item =
      for entry <- assigns.entries, item <- assigns.item do
        item_heading = Map.get(item, :heading)
        entry_heading = Map.get(entry, :heading)

        if item_heading && entry_heading do
          raise ArgumentError, "specify heading in either :item or :entries"
        end

        heading = item_heading || entry_heading

        item
        |> Map.put(:heading, heading)
        |> Map.put(:entry, entry)
      end

    assigns = assign(assigns, :item, item)

    ~H"""
    <div
      id={@container_id}
      class={@class}
      {@rest}
      {js_attributes("container", @js_lib, @container_id, nil, nil)}
    >
      <%= for {current_item, i} <- Enum.with_index(@item) do %>
        <div {js_attributes("item", @js_lib, @container_id, i, length(@item))} data-i={i}>
          <h2>
            <button
              type="button"
              {js_attributes("button", @js_lib, @container_id, i, length(@item))}
              class={[
                "flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800 accordion-button",
                if(i == 0, do: "rounded-t-xl"),
                unless(i == length(@item) - 1, do: "border-b-0"),
                if(i == length(@item) - 1,
                  do:
                    "flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800--last #{if @js_lib == "live_view_js", do: "flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800--last--closed"}"
                )
              ]}
            >
              <span class="text-base font-semibold">
                <%= current_item.heading %>
              </span>

              <Heroicons.chevron_down
                solid
                class="flex-shrink-0 w-6 h-6 ml-3 text-gray-400 duration-300 fill-current dark:group-hover:text-gray-300 group-hover:text-gray-500"
                {js_attributes("icon", @js_lib, @container_id, i, length(@item))}
              />
            </button>
          </h2>
          <div
            {js_attributes("content_container", @js_lib, @container_id, i, length(@item))}
            class="accordion-content-container"
          >
            <div class={[
              "p-5 bg-white border border-gray-200 dark:border-gray-700 dark:bg-gray-900",
              if(i == length(@item) - 1,
                do: "border-t-0",
                else: "border-b-0"
              )
            ]}>
              <%= render_slot(current_item, current_item.entry) %>
            </div>
          </div>
        </div>
      <% end %>
    </div>

    <script>
      window.addEventListener("click_accordion", e => {
        let i = e.detail.index;
        let l = e.detail.length
        let clickedAccordionItem = e.target;
        let currentlyOpenAccordionItem = document.querySelector("[data-open='true']")
        let isClosingClickedAccordionItem = !!currentlyOpenAccordionItem && currentlyOpenAccordionItem == clickedAccordionItem;
        let isLastAccordionItem = i == l - 1;

        // Close open accordion item
        if(currentlyOpenAccordionItem) {
          currentlyOpenAccordionItem.dataset.open = false
          currentlyOpenAccordionItem.querySelector("svg").classList.remove("rotate-180");
          currentlyOpenAccordionItem.querySelector(`.accordion-content-container`).style.display = "none";
          currentlyOpenAccordionItem.querySelector(`.accordion-button`).classList.remove("bg-gray-50 dark:bg-gray-800");
          if(isLastAccordionItem){
            clickedAccordionItem.querySelector(`.accordion-button`).classList.add("flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800--last--closed");
          }
        }

        // Open clicked accordion item (if not already open)
        if (!isClosingClickedAccordionItem) {
          clickedAccordionItem.dataset.open = true
          clickedAccordionItem.querySelector("svg").classList.add("rotate-180");
          clickedAccordionItem.querySelector(`.accordion-content-container`).style.display = "block";
          clickedAccordionItem.querySelector(`.accordion-button`).classList.add("bg-gray-50 dark:bg-gray-800");
          if(isLastAccordionItem){
            clickedAccordionItem.querySelector(`.accordion-button`).classList.remove("flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800--last--closed");
          }
        }
      })
    </script>
    """
  end

  defp js_attributes("container", "alpine_js", _container_id, _i, _) do
    %{
      "x-data": "{ active: null }"
    }
  end

  defp js_attributes("item", "alpine_js", _container_id, i, _) do
    %{
      "x-data": "{
        id: #{i},
        get expanded() {
          return this.active === this.id
        },
        set expanded(value) {
          this.active = value ? this.id : null
        },
      }"
    }
  end

  defp js_attributes("button", "alpine_js", _container_id, i, l) when i == l - 1 do
    %{
      "x-on:click": "expanded = !expanded",
      ":class":
        "expanded ? 'bg-gray-50 dark:bg-gray-800' : 'flex items-center justify-between w-full p-5 text-left text-gray-800 bg-white border border-gray-200 dark:bg-gray-900 dark:border-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-gray-800--last--closed'",
      ":aria-expanded": "expanded"
    }
  end

  defp js_attributes("button", "alpine_js", _container_id, _i, _l) do
    %{
      "x-on:click": "expanded = !expanded",
      ":class":
        "expanded ? 'bg-gray-50 dark:bg-gray-800' : ''",
      ":aria-expanded": "expanded"
    }
  end

  defp js_attributes("content_container", "alpine_js", _container_id, _, _) do
    %{
      "x-show": "expanded",
      "x-cloak": true,
      "x-collapse": true
    }
  end

  defp js_attributes("icon", "alpine_js", _container_id, _, _) do
    %{
      ":class": "{ 'rotate-180': expanded }"
    }
  end

  defp js_attributes("container", "live_view_js", _container_id, _i, _) do
    %{}
  end

  defp js_attributes("item", "live_view_js", _container_id, _i, _) do
    %{}
  end

  defp js_attributes("button", "live_view_js", container_id, i, l) do
    %{
      "phx-click":
        JS.dispatch("click_accordion",
          to: "##{container_id} [data-i='#{i}']",
          detail: %{container_id: container_id, index: i, length: l}
        )
    }
  end

  defp js_attributes("content_container", "live_view_js", _container_id, _i, _) do
    %{
      style: "display: none;"
    }
  end

  defp js_attributes("icon", "live_view_js", _container_id, _, _) do
    %{}
  end
end
