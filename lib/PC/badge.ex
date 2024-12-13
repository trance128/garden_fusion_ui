defmodule AlgoAlchemyWeb.PC.Badge do
  use Phoenix.Component

  attr(:size, :string, default: "md", values: ["xs", "sm", "md", "lg", "xl"])
  attr(:variant, :string, default: "light", values: ["light", "dark", "soft", "outline"])

  attr(:color, :string,
    default: "primary",
    values: ["primary", "secondary", "info", "success", "warning", "danger", "gray"]
  )

  attr(:role, :string, default: "note", values: ["note", "status"])
  attr(:with_icon, :boolean, default: false, doc: "adds some icon base classes")
  attr(:class, :any, default: nil, doc: "CSS class for parent div")
  attr(:label, :string, default: nil, doc: "label your badge")
  attr(:rest, :global)
  slot(:inner_block, required: false)

  def badge(assigns) do
    ~H"""
    <badge
      {@rest}
      role={@role}
      class={[
        "inline-flex items-center justify-center border rounded focus:outline-none",
        size_class(@size),
        color_variant_class(@color, @variant),
        @class
      ]}
    >
      <%= render_slot(@inner_block) || @label %>
    </badge>
    """
  end

  defp size_class("sm") do
    "text-[0.625rem] font-semibold px-1.5"
  end
  defp size_class("md") do
    "text-xs font-semibold px-2.5 py-0.5"
  end
  defp size_class("lg") do
    "text-sm font-semibold px-2.5 py-0.5"
  end

  defp color_variant_class("primary", "light") do
    "text-primary-800 bg-primary-100 border-primary-100 dark:bg-primary-200 dark:border-primary-200"
  end

  defp color_variant_class("primary", "soft") do
    "text-primary-800 bg-primary-100 border-primary-100 dark:border-primary-900 dark:bg-blue-900 dark:text-blue-300"
  end

  defp color_variant_class("primary", "dark") do
    "text-white bg-primary-600 border-primary-600"
  end

  defp color_variant_class("primary", "outline") do
    "text-primary-600 border-primary-600 dark:text-primary-400 dark:border-primary-400"
  end

  defp color_variant_class("secondary", "light") do
    "text-secondary-800 bg-secondary-100 border-secondary-100 dark:bg-secondary-200 dark:border-secondary-200"
  end

  defp color_variant_class("secondary", "soft") do
    "text-secondary-800 bg-secondary-100 border-secondary-100 dark:border-secondary-900 dark:bg-secondary-800 dark:text-secondary-300"
  end

  defp color_variant_class("secondary", "dark") do
    "text-white bg-secondary-600 border-secondary-600"
  end

  defp color_variant_class("secondary", "outline") do
    "border text-secondary-600 border-secondary-600 dark:text-secondary-400 dark:border-secondary-400"
  end

  defp color_variant_class("info", "light") do
    "text-info-800 bg-info-100 border-info-100 dark:bg-info-200 dark:border-info-200"
  end

  defp color_variant_class("info", "soft") do
    "text-info-800 bg-info-100 border-info-100 dark:border-info-900 dark:bg-info-900 dark:text-info-300"
  end

  defp color_variant_class("info", "dark") do
    "text-white bg-info-600 border-info-600"
  end

  defp color_variant_class("info", "outline") do
    "border text-info-600 border-info-600 dark:text-info-400 dark:border-info-400"
  end

  defp color_variant_class("success", "light") do
    "text-success-800 bg-success-100 border-success-100 dark:bg-success-200 dark:border-success-200"
  end

  defp color_variant_class("success", "soft") do
    "text-success-800 bg-success-100 border-success-100 dark:border-success-900 dark:bg-success-900 dark:text-success-300"
  end

  defp color_variant_class("success", "dark") do
    "text-white bg-success-600 border-success-600"
  end

  defp color_variant_class("success", "outline") do
    "border text-success-600 border-success-600 dark:text-success-400 dark:border-success-400"
  end

  defp color_variant_class("warning", "light") do
    "text-warning-800 bg-warning-100 border-warning-100 dark:bg-warning-200 dark:border-warning-200"
  end

  defp color_variant_class("warning", "soft") do
    "text-warning-800 bg-warning-100 border-warning-100 dark:border-warning-900 dark:bg-warning-900 dark:text-warning-300"
  end

  defp color_variant_class("warning", "dark") do
    "text-white bg-warning-600 border-warning-600"
  end

  defp color_variant_class("warning", "outline") do
    "border text-warning-600 border-warning-600 dark:text-warning-400 dark:border-warning-400"
  end

  defp color_variant_class("danger", "light") do
    "text-danger-800 bg-danger-100 border-danger-100 dark:bg-danger-200 dark:border-danger-200"
  end

  defp color_variant_class("danger", "soft") do
    "text-danger-800 bg-danger-100 border-danger-100 dark:border-danger-900 dark:bg-danger-900 dark:text-danger-300"
  end

  defp color_variant_class("danger", "dark") do
    "text-white bg-danger-600 border-danger-600"
  end

  defp color_variant_class("danger", "outline") do
    "border text-danger-600 border-danger-600 dark:text-danger-400 dark:border-danger-400"
  end

  defp color_variant_class("gray", "light") do
    "text-gray-800 bg-gray-100 border-gray-100 dark:bg-gray-200 dark:border-gray-200"
  end

  defp color_variant_class("gray", "soft") do
    "text-gray-800 bg-gray-100 border-gray-100 dark:border-gray-700 dark:bg-gray-700 dark:text-gray-300"
  end

  defp color_variant_class("gray", "dark") do
    "text-white bg-gray-600 border-gray-600 dark:bg-gray-700 dark:border-gray-700"
  end

  defp color_variant_class("gray", "outline") do
    "text-gray-600 border border-gray-600 dark:text-gray-400 dark:border-gray-400"
  end
end
