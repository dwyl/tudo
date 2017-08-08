defmodule Tudo.HTTPoison.HTTPoison do
  @moduledoc false
  require HTTPoison

  defdelegate request!(method, url, body, headers, options), to: HTTPoison
end
