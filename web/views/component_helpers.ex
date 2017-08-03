defmodule Tudo.ComponentHelpers do
  @moduledoc """
  Renders all of the component files and tells them how to use their arguments,
  e.g. to choose the name of the template and what to do with text and classes
  """

  alias Tudo.ComponentView

  def component(template, assigns) do
    ComponentView.render "#{template}.html", assigns
  end
end
