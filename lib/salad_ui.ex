defmodule SaladUI do
  @moduledoc false
  def component do
    quote do
      use Phoenix.Component

      import SaladUI.Helpers

      # alias OrangeCmsWeb.Components.LadUI.LadJS
      alias Phoenix.LiveView.JS
    end
  end

  @doc """
  When used, dispatch to the appropriate macro.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
