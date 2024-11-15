defmodule PC.Input do
  use Phoenix.Component
  import PC.Icon

  @moduledoc """
  Renders pure inputs (no label or errors).
  """

  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select switch tel text textarea time url week)

  attr :size, :string, default: "md", values: ~w(xs sm md lg xl), doc: "the size of the switch"

  attr :viewable, :boolean,
    default: false,
    doc: "If true, adds a toggle to show/hide the password text"

  attr :copyable, :boolean,
    default: false,
    doc: "If true, adds a copy button to the field and disables the input"

  attr :clearable, :boolean,
    default: false,
    doc: "If true, adds a clear button to clear the field value"

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :any, default: nil, doc: "the class to add to the input"

  attr :rest, :global,
    include:
      ~w(autocomplete autocorrect autocapitalize disabled form max maxlength min minlength list
    pattern placeholder readonly required size step value name multiple prompt selected default year month day hour minute second builder options layout cols rows wrap checked accept)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign_new(:name, fn ->
      if assigns.multiple, do: field.name <> "[]", else: field.name
    end)
    |> assign_new(:value, fn -> field.value end)
    |> assign_new(:label, fn -> PhoenixHTMLHelpers.Form.humanize(field.field) end)
    |> assign(class: [assigns.class, get_class_for_type(assigns.type)])
    |> input()
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <select id={@id} name={@name} class={[@class, "block w-full border-gray-300 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500 sm:text-sm disabled:bg-gray-100 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:disabled:bg-gray-700 focus:outline-none"]} multiple={@multiple} {@rest}>
      <option :if={@prompt} value=""><%= @prompt %></option>
      <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
    </select>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <textarea id={@id} name={@name} class={[@class, "block w-full border-gray-300 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500 sm:text-sm disabled:bg-gray-100 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:disabled:bg-gray-700 focus:outline-none"]} {@rest}><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
    """
  end

  def input(%{type: "switch", value: value} = assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <label class={["relative inline-flex items-center justify-center flex-shrink-0 cursor-pointer", "relative inline-flex items-center justify-center flex-shrink-0 cursor-pointer--#{@size}"]}>
      <input
        type="checkbox"
        id={@id}
        name={@name}
        value="true"
        checked={@checked}
        class={["sr-only peer", @class]}
        {@rest}
      />

      <span class={["absolute mx-auto transition-colors duration-200 ease-in-out bg-gray-200 border border-gray-300 rounded-full pointer-events-none dark:bg-gray-700 dark:border-gray-600 peer-checked:bg-primary-500", "absolute mx-auto transition-colors duration-200 ease-in-out bg-gray-200 border border-gray-300 rounded-full pointer-events-none dark:bg-gray-700 dark:border-gray-600 peer-checked:bg-primary-500--#{@size}"]}></span>
      <span class={["absolute left-0 inline-block transition-transform duration-200 ease-in-out transform translate-x-0 bg-white rounded-full shadow pointer-events-none ring-0", "absolute left-0 inline-block transition-transform duration-200 ease-in-out transform translate-x-0 bg-white rounded-full shadow pointer-events-none ring-0--#{@size}"]}></span>
    </label>
    """
  end

  def input(%{type: "password", viewable: true} = assigns) do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <div class="relative" x-data="{ show: false }">
      <input
        x-bind:type="show ? 'text' : 'password'"
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[@class, "pr-10"]}
        {@rest}
      />
      <button type="button" class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-500" @click="show = !show">
        <span x-show="!show" class="flex items-center">
          <.icon name="hero-eye-solid" class="w-5 h-5 text-gray-400" />
        </span>
        <span x-show="show" class="flex items-center" style="display: none;">
          <.icon name="hero-eye-slash-solid" class="w-5 h-5 text-gray-400" />
        </span>
      </button>
    </div>
    """
  end

  def input(%{type: type, copyable: true} = assigns) when type in ["text", "url", "email"] do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <div class="relative" x-data="{ copied: false }">
      <input
        x-ref="copyInput"
        type={@type || "text"}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type || "text", @value)}
        class={[@class, "pr-10 cursor-text"]}
        readonly
        {@rest}
      />
      <button
        type="button"
        class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-500 bg-transparent border-none cursor-pointer"
        @click="
          navigator.clipboard.writeText($refs.copyInput.value)
            .then(() => { copied = true; setTimeout(() => copied = false, 2000); })
        "
      >
        <span x-show="!copied" class="flex items-center">
          <.icon name="hero-clipboard-document-solid" class="w-5 h-5 text-gray-400" />
        </span>
        <span x-show="copied" class="flex items-center" style="display: none;">
          <.icon name="hero-clipboard-document-check-solid" class="w-5 h-5 text-gray-400" />
        </span>
      </button>
    </div>
    """
  end

  def input(%{type: type, clearable: true} = assigns)
      when type in ["text", "search", "url", "email", "tel"] do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <div
      class="relative"
      x-data="{ showClearButton: false }"
      x-init="showClearButton = $refs.clearInput.value.length > 0"
    >
      <input
        x-ref="clearInput"
        type={@type || "text"}
        name={@name}
        id={@id}
        value={@value}
        class={[@class, "pr-10"]}
        {@rest}
        x-on:input="showClearButton = $event.target.value.length > 0"
      />
      <button
        type="button"
        class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-500 bg-transparent border-none cursor-pointer"
        x-show="showClearButton"
        x-on:click="
          $refs.clearInput.value = '';
          showClearButton = false;
          $refs.clearInput.dispatchEvent(new Event('input'));
        "
        style="display: none;"
        aria-label="Clear input"
      >
        <span class="flex items-center">
          <.icon name="hero-x-mark-solid" class="w-5 h-5 text-gray-500 dark:text-gray-400" />
        </span>
      </button>
    </div>
    """
  end

  def input(%{type: type} = assigns)
      when type in ["date", "datetime-local", "time", "month", "week"] do
    assigns =
      assign(assigns,
        class: [assigns.class, "pc-text-input [-webkit-appearance:none] [&::-webkit-datetime-edit-fields-wrapper]:p-0 [&::-webkit-date-and-time-value]:text-black dark:[&::-webkit-date-and-time-value]:text-white [&::-webkit-calendar-picker-indicator]:opacity-0 [&::-webkit-calendar-picker-indicator]:absolute [&::-webkit-calendar-picker-indicator]:inset-y-0 [&::-webkit-calendar-picker-indicator]:right-0 [&::-webkit-calendar-picker-indicator]:w-10 [&::-webkit-calendar-picker-indicator]:h-full [&::-webkit-calendar-picker-indicator]:cursor-pointer"],
        icon_name: get_icon_for_type(assigns.type)
      )

    ~H"""
    <div class="relative">
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={@class}
        {@rest}
      />
      <button
        type="button"
        class="absolute inset-y-0 right-0 flex items-center my-1 mr-3 bg-white pointer-events-none dark:bg-gray-800"
        onclick="this.previousElementSibling.showPicker()"
      >
        <.icon name={@icon_name} class="w-5 h-5 text-gray-400" />
      </button>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <input
      type={@type}
      name={@name}
      id={@id}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      class={@class}
      {@rest}
    />
    """
  end

  defp get_class_for_type("radio"), do: "w-4 h-4 border-gray-300 cursor-pointer text-primary-600 focus:ring-primary-500 dark:bg-gray-800 dark:border-gray-600"
  defp get_class_for_type("checkbox"), do: "w-5 h-5 transition-all duration-150 ease-linear border-gray-300 rounded cursor-pointer text-primary-700 dark:bg-gray-800 dark:border-gray-600 disabled:bg-gray-300 dark:disabled:bg-gray-600 disabled:cursor-not-allowed"
  defp get_class_for_type("color"), do: "border-gray-300 cursor-pointer focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500"
  defp get_class_for_type("file"), do: "text-sm rounded-md cursor-pointer focus:outline-none file:border-0 text-slate-500 file:text-primary-700 file:font-semibold file:px-4 file:py-2 file:mr-6 file:rounded-md hover:file:bg-primary-100 file:bg-primary-200 dark:file:bg-primary-300 hover:dark:file:bg-primary-200"
  defp get_class_for_type("range"), do: "w-full border-gray-300 cursor-pointer focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500"
  defp get_class_for_type(_), do: "block w-full border-gray-300 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500 sm:text-sm disabled:bg-gray-100 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:disabled:bg-gray-700 focus:outline-none"

  defp get_icon_for_type("date"), do: "hero-calendar"
  defp get_icon_for_type("datetime-local"), do: "hero-calendar"
  defp get_icon_for_type("month"), do: "hero-calendar"
  defp get_icon_for_type("week"), do: "hero-calendar"
  defp get_icon_for_type("time"), do: "hero-clock"
end
