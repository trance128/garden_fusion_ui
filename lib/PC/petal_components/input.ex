defmodule PC.Input do
  use Phoenix.Component

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

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :class, :string, default: nil, doc: "the class to add to the input"

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
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <label class="relative inline-flex items-center justify-center flex-shrink-0 w-10 h-5 cursor-pointer">
      <input
        type="checkbox"
        id={@id}
        name={@name}
        value="true"
        checked={@checked}
        class={["sr-only peer", @class]}
        {@rest}
      />

      <span class="absolute h-6 mx-auto transition-colors duration-200 ease-in-out bg-gray-200 border rounded-full pointer-events-none w-11 dark:bg-gray-700 dark:border-gray-600 peer-checked:bg-primary-500"></span>
      <span class="absolute left-0 inline-block w-5 h-5 transition-transform duration-200 ease-in-out transform translate-x-0 bg-white rounded-full shadow pointer-events-none peer-checked:translate-x-5 ring-0"></span>
    </label>
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
end
