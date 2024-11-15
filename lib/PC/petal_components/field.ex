defmodule PC.Field do
  use Phoenix.Component
  import PC.Icon

  @doc """
  Renders an input with label and error messages. If you just want an input, check out input.ex

  A `%Phoenix.HTML.FormField{}` and type may be passed to the field
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.field field={@form[:email]} type="email" />
      <.field label="Name" value="" name="name" errors={["oh no!"]} />
  """
  attr :id, :any,
    default: nil,
    doc: "the id of the input. If not passed, it will be generated automatically from the field"

  attr :name, :any,
    doc: "the name of the input. If not passed, it will be generated automatically from the field"

  attr :label, :string,
    doc:
      "the label for the input. If not passed, it will be generated automatically from the field"

  attr :value, :any,
    doc:
      "the value of the input. If not passed, it will be generated automatically from the field"

  attr :type, :string,
    default: "text",
    values:
      ~w(checkbox checkbox-group color date datetime-local email file hidden month number password
               range radio-group radio-card search select switch tel text textarea time url week),
    doc: "the type of input"

  attr :size, :string,
    default: "md",
    values: ~w(xs sm md lg xl),
    doc: "the size of the switch (xs, sm, md, lg or xl) or radio card (sm, md or lg)"

  attr :variant, :any, default: "outline", doc: "outline, classic - used by radio-card"

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

  attr :errors, :list,
    default: [],
    doc:
      "a list of errors to display. If not passed, it will be generated automatically from the field. Format is a list of strings."

  attr :checked, :any, doc: "the checked flag for checkboxes and checkbox groups"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :disabled_options, :list, default: [], doc: "the options to disable in a checkbox group"

  attr :group_layout, :string,
    values: ["row", "col"],
    default: "row",
    doc: "the layout of the inputs in a group (checkbox-group or radio-group)"

  attr :empty_message, :string,
    default: nil,
    doc:
      "the message to display when there are no options available, for checkbox-group or radio-group"

  attr :rows, :string, default: "4", doc: "rows for textarea"

  attr :class, :any, default: nil, doc: "the class to add to the input"
  attr :wrapper_class, :any, default: nil, doc: "the wrapper div classes"
  attr :help_text, :string, default: nil, doc: "context/help for your field"
  attr :label_class, :any, default: nil, doc: "extra CSS for your label"
  attr :selected, :any, default: nil, doc: "the selected value for select inputs"

  attr :required, :boolean,
    default: false,
    doc: "is this field required? is passed to the input and adds an asterisk next to the label"

  attr :rest, :global,
    include:
      ~w(autocomplete autocorrect autocapitalize disabled form max maxlength min minlength list
    pattern placeholder readonly required size step value name multiple prompt default year month day hour minute second builder options layout cols rows wrap checked accept),
    doc: "All other props go on the input"

  def field(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn ->
      if assigns.multiple && assigns.type not in ["checkbox-group", "radio-group"],
        do: field.name <> "[]",
        else: field.name
    end)
    |> assign_new(:value, fn -> field.value end)
    |> assign_new(:label, fn -> PhoenixHTMLHelpers.Form.humanize(field.field) end)
    |> field()
  end

  def field(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <label class={["inline-flex items-center gap-3 text-sm font-normal text-gray-900 cursor-pointer dark:text-gray-200", @label_class]}>
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          required={@required}
          class={["w-5 h-5 transition-all duration-150 ease-linear border-gray-300 rounded cursor-pointer text-primary-700 dark:bg-gray-800 dark:border-gray-600 disabled:bg-gray-300 dark:disabled:bg-gray-600 disabled:cursor-not-allowed", @class]}
          {@rest}
        />
        <div class={[@required && "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200--required"]}>
          <%= @label %>
        </div>
      </label>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "select"} = assigns) do
    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <select
        id={@id}
        name={@name}
        class={["block w-full border-gray-300 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500 sm:text-sm disabled:bg-gray-100 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:disabled:bg-gray-700 focus:outline-none", @class]}
        multiple={@multiple}
        required={@required}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @selected || @value) %>
      </select>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "textarea"} = assigns) do
    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <textarea
        id={@id}
        name={@name}
        class={["block w-full border-gray-300 rounded-md shadow-sm focus:border-primary-500 focus:ring-primary-500 dark:border-gray-600 dark:focus:border-primary-500 sm:text-sm disabled:bg-gray-100 disabled:cursor-not-allowed dark:bg-gray-800 dark:text-gray-300 dark:disabled:bg-gray-700 focus:outline-none", @class]}
        rows={@rows}
        required={@required}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "switch", value: value} = assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <label class={["inline-flex items-center gap-3 text-sm font-normal text-gray-900 cursor-pointer dark:text-gray-200", @label_class]}>
        <input type="hidden" name={@name} value="false" />
        <label class={["relative inline-flex items-center justify-center flex-shrink-0 cursor-pointer", "relative inline-flex items-center justify-center flex-shrink-0 cursor-pointer--#{@size}"]}>
          <input
            type="checkbox"
            id={@id}
            name={@name}
            value="true"
            checked={@checked}
            required={@required}
            class={["sr-only peer", @class]}
            {@rest}
          />

          <span class={["absolute mx-auto transition-colors duration-200 ease-in-out bg-gray-200 border border-gray-300 rounded-full pointer-events-none dark:bg-gray-700 dark:border-gray-600 peer-checked:bg-primary-500", "absolute mx-auto transition-colors duration-200 ease-in-out bg-gray-200 border border-gray-300 rounded-full pointer-events-none dark:bg-gray-700 dark:border-gray-600 peer-checked:bg-primary-500--#{@size}"]}></span>
          <span class={["absolute left-0 inline-block transition-transform duration-200 ease-in-out transform translate-x-0 bg-white rounded-full shadow pointer-events-none ring-0", "absolute left-0 inline-block transition-transform duration-200 ease-in-out transform translate-x-0 bg-white rounded-full shadow pointer-events-none ring-0--#{@size}"]}></span>
        </label>
        <div class={[@required && "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200--required"]}><%= @label %></div>
      </label>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "checkbox-group"} = assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn ->
        values =
          case assigns.value do
            value when is_binary(value) -> [value]
            value when is_list(value) -> value
            _ -> []
          end

        Enum.map(values, &to_string/1)
      end)

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} class={@label_class}>
        <%= @label %>
      </.field_label>
      <input type="hidden" name={@name} value="" />
      <div class={[
        "pt-2",
        @group_layout == "row" && "flex flex-row gap-4 mb-3",
        @group_layout == "col" && "flex flex-col gap-4 mb-3",
        @class
      ]}>
        <%= for {label, value} <- @options do %>
          <label class="inline-flex items-center gap-3 text-sm font-normal text-gray-900 cursor-pointer dark:text-gray-200">
            <input
              type="checkbox"
              name={@name <> "[]"}
              checked_value={value}
              unchecked_value=""
              value={value}
              checked={to_string(value) in @checked}
              hidden_input={false}
              class="w-5 h-5 transition-all duration-150 ease-linear border-gray-300 rounded cursor-pointer text-primary-700 dark:bg-gray-800 dark:border-gray-600 disabled:bg-gray-300 dark:disabled:bg-gray-600 disabled:cursor-not-allowed"
              disabled={value in @disabled_options}
              {@rest}
            />
            <div>
              <%= label %>
            </div>
          </label>
        <% end %>

        <%= if @empty_message && Enum.empty?(@options) do %>
          <div class="pt-2--empty-message">
            <%= @empty_message %>
          </div>
        <% end %>
      </div>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "radio-group"} = assigns) do
    assigns = assign_new(assigns, :checked, fn -> nil end)

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} class={@label_class}>
        <%= @label %>
      </.field_label>
      <div class={[
        "pt-2",
        @group_layout == "row" && "flex flex-row gap-4 mb-3",
        @group_layout == "col" && "flex flex-col gap-4 mb-3",
        @class
      ]}>
        <input type="hidden" name={@name} value="" />
        <%= for {label, value} <- @options do %>
          <label class="inline-flex items-center gap-3 text-sm font-normal text-gray-900 cursor-pointer dark:text-gray-200">
            <input
              type="radio"
              name={@name}
              value={value}
              checked={
                to_string(value) == to_string(@value) || to_string(value) == to_string(@checked)
              }
              class="w-4 h-4 border-gray-300 cursor-pointer text-primary-600 focus:ring-primary-500 dark:bg-gray-800 dark:border-gray-600"
              {@rest}
            />
            <div>
              <%= label %>
            </div>
          </label>
        <% end %>

        <%= if @empty_message && Enum.empty?(@options) do %>
          <div class="pt-2--empty-message">
            <%= @empty_message %>
          </div>
        <% end %>
      </div>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "radio-card"} = assigns) do
    assigns =
      assigns
      |> assign_new(:checked, fn -> nil end)
      |> assign_new(:options, fn -> [] end)
      |> assign_new(:group_layout, fn -> "row" end)
      |> assign_new(:id_prefix, fn -> assigns.id || assigns.name || "radio_card" end)

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} class={@label_class}>
        <%= @label %>
      </.field_label>
      <div class={[
        "flex gap-4",
        "flex gap-4--#{@group_layout}",
        @class
      ]}>
        <input type="hidden" name={@name} value="" />
        <%= for option <- @options do %>
          <label class={[
            "relative transition-all cursor-pointer select-none flex items-center justify-center text-left text-gray-900 dark:text-white",
            "relative transition-all cursor-pointer select-none flex items-center justify-center text-left text-gray-900 dark:text-white--#{@size}",
            "relative transition-all cursor-pointer select-none flex items-center justify-center text-left text-gray-900 dark:text-white--#{@variant}",
            option[:disabled] && "opacity-50 cursor-not-allowed"
          ]}>
            <input
              type="radio"
              name={@name}
              id={"#{@id_prefix}_#{option[:value]}"}
              value={option[:value]}
              disabled={option[:disabled]}
              checked={
                to_string(option[:value]) == to_string(@value) ||
                  to_string(option[:value]) == to_string(@checked)
              }
              class="sr-only sr-only"
              {@rest}
            />
            <div class="absolute inset-0 rounded-lg"></div>
            <div class="relative pointer-events-none">
              <div class="font-semibold"><%= option[:label] %></div>
              <div :if={option[:description]} class="text-sm font-normal text-gray-600 dark:text-gray-400">
                <%= option[:description] %>
              </div>
            </div>
          </label>
        <% end %>
        <%= if @empty_message && Enum.empty?(@options) do %>
          <div class="flex gap-4--empty-message">
            <%= @empty_message %>
          </div>
        <% end %>
      </div>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: "hidden"} = assigns) do
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

  def field(%{type: "password", viewable: true} = assigns) do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <div class="relative" x-data="{ show: false }">
        <input
          x-bind:type="show ? 'text' : 'password'"
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={[@class, "pr-10"]}
          required={@required}
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
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: type, copyable: true} = assigns) when type in ["text", "url", "email"] do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <!-- Field Label -->
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <!-- Copyable Field Wrapper -->
      <div class="relative" x-data="{ copied: false }">
        <!-- Input Field -->
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
        <!-- Copy Button -->
        <button
          type="button"
          class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-500 bg-transparent border-none cursor-pointer"
          @click="
          navigator.clipboard.writeText($refs.copyInput.value)
            .then(() => { copied = true; setTimeout(() => copied = false, 2000); })
        "
        >
          <!-- Copy Icon -->
          <span x-show="!copied" class="flex items-center">
            <.icon name="hero-clipboard-document-solid" class="w-5 h-5 text-gray-400" />
          </span>
          <!-- Copied Icon -->
          <span x-show="copied" class="flex items-center" style="display: none;">
            <.icon name="hero-clipboard-document-check-solid" class="w-5 h-5 text-gray-400" />
          </span>
        </button>
      </div>
      <!-- Error Message -->
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <!-- Help Text -->
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: type, clearable: true} = assigns)
      when type in ["text", "search", "url", "email", "tel"] do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <!-- Field Label -->
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <!-- Clearable Field Wrapper -->
      <div
        class="relative"
        x-data="{ showClearButton: false }"
        x-init="showClearButton = $refs.clearInput.value.length > 0"
      >
        <!-- Input Field -->
        <input
          x-ref="clearInput"
          type={@type || "text"}
          name={@name}
          id={@id}
          value={@value}
          class={[@class, "pr-10"]}
          required={@required}
          {@rest}
          x-on:input="showClearButton = $event.target.value.length > 0"
        />
        <!-- Clear Button -->
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
          <!-- Clear Icon -->
          <span class="flex items-center">
            <.icon name="hero-x-mark-solid" class="w-5 h-5 text-gray-500 dark:text-gray-400" />
          </span>
        </button>
      </div>
      <!-- Error Message -->
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <!-- Help Text -->
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  def field(%{type: type} = assigns)
      when type in ["date", "datetime-local", "time", "month", "week"] do
    assigns =
      assign(assigns,
        class: [assigns.class, "pc-text-input [-webkit-appearance:none] [&::-webkit-datetime-edit-fields-wrapper]:p-0 [&::-webkit-date-and-time-value]:text-black dark:[&::-webkit-date-and-time-value]:text-white [&::-webkit-calendar-picker-indicator]:opacity-0 [&::-webkit-calendar-picker-indicator]:absolute [&::-webkit-calendar-picker-indicator]:inset-y-0 [&::-webkit-calendar-picker-indicator]:right-0 [&::-webkit-calendar-picker-indicator]:w-10 [&::-webkit-calendar-picker-indicator]:h-full [&::-webkit-calendar-picker-indicator]:cursor-pointer"],
        icon_name: get_icon_for_type(assigns.type)
      )

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <div class="relative">
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          class={@class}
          required={@required}
          {@rest}
        />
        <div class="absolute inset-y-0 right-0 flex items-center my-1 mr-3 bg-white pointer-events-none dark:bg-gray-800">
          <.icon name={@icon_name} class="w-5 h-5 text-gray-400" />
        </div>
      </div>
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  # All other inputs (text, url, etc.) are handled here...
  def field(assigns) do
    assigns = assign(assigns, class: [assigns.class, get_class_for_type(assigns.type)])

    ~H"""
    <.field_wrapper errors={@errors} name={@name} class={@wrapper_class}>
      <.field_label required={@required} for={@id} class={@label_class}>
        <%= @label %>
      </.field_label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={@class}
        required={@required}
        {@rest}
      />
      <.field_error :for={msg <- @errors}><%= msg %></.field_error>
      <.field_help_text help_text={@help_text} />
    </.field_wrapper>
    """
  end

  attr :class, :any, default: nil
  attr :errors, :list, default: []
  attr :name, :string
  attr :rest, :global
  slot :inner_block, required: true

  def field_wrapper(assigns) do
    ~H"""
    <div
      phx-feedback-for={@name}
      {@rest}
      class={[
        @class,
        "mb-6",
        @errors != [] && "mb-6--error"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  attr :required, :boolean, default: false
  slot :inner_block, required: true

  def field_label(assigns) do
    ~H"""
    <%= if @for do %>
      <label for={@for} class={["block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200", @class, @required && "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200--required"]} {@rest}>
        <%= render_slot(@inner_block) %>
      </label>
    <% else %>
      <span class={["block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200", @class, @required && "block mb-2 text-sm font-medium text-gray-900 dark:text-gray-200--required"]} {@rest}>
        <%= render_slot(@inner_block) %>
      </span>
    <% end %>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def field_error(assigns) do
    ~H"""
    <p class="mt-1 text-xs italic text-danger-500">
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  attr :class, :any, default: nil, doc: "extra classes for the help text"
  attr :help_text, :string, default: nil, doc: "context/help for your field"
  slot :inner_block, required: false
  attr :rest, :global

  def field_help_text(assigns) do
    ~H"""
    <div :if={render_slot(@inner_block) || @help_text} class={["mt-2 text-sm text-gray-500 dark:text-gray-400", @class]} {@rest}>
      <%= render_slot(@inner_block) || @help_text %>
    </div>
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

  defp translate_error({msg, opts}) do
    config_translator = get_translator_from_config()

    if config_translator do
      config_translator.({msg, opts})
    else
      fallback_translate_error(msg, opts)
    end
  end

  defp fallback_translate_error(msg, opts) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      try do
        String.replace(acc, "%{#{key}}", to_string(value))
      rescue
        e ->
          IO.warn(
            """
            the fallback message translator for the form_field_error function cannot handle the given value.

            Hint: you can set up the `error_translator_function` to route all errors to your application helpers:

              config :petal_components, :error_translator_function, {MyAppWeb.CoreComponents, :translate_error}

            Given value: #{inspect(value)}

            Exception: #{Exception.message(e)}
            """,
            __STACKTRACE__
          )

          "invalid value"
      end
    end)
  end

  defp get_translator_from_config do
    case Application.get_env(:petal_components, :error_translator_function) do
      {module, function} -> &apply(module, function, [&1])
      nil -> nil
    end
  end
end
