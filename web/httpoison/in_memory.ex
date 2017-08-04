defmodule Tudo.HTTPoison.InMemory do
  @moduledoc"""
  In memory serving of fixtures for testing githubs api
  Based off of this mocking convention:
  http://blog.plataformatec.com.br/2015/10/mocks-and-explicit-contracts/
  """

  require Poison

  def request!(method, url, body, headers, _options \\ []) do
    try do
      [{"Authorization", token}, {"User-agent", _user_agent}] = headers
      if String.length(token) < 15 do
        raise "err"
      end
    rescue
      RuntimeError -> "Invalid headers set, check your environment variables"
    end

    # Take off the https://api.github.com prefix from the start of the url
    "https://api.github.com" <> url = url

    case method do
      "get" -> %{body: url |> get! |> Poison.encode!}
      "post" -> %{body: url |> post!(body) |> Poison.encode!}
      "delete" -> %{body: url |> delete! |> Poison.encode!}
    end
  end

  defp get!("/"), do: %{"method" => "get"}
  defp get!("/orgs/200repos/repos?per_page=100&page=" <> page) do
    case page do
      "1" -> 1..100 |> Enum.map(&(%{"name" => "repo#{&1}"}))
      "2" -> 101..200 |> Enum.map(&(%{"name" => "repo#{&1}"}))
      "3" -> []
    end
  end

  defp get!("/orgs/dwyl/repos?per_page=100&page=" <> page) do
    case page do
      "1" -> 1..100 |> Enum.map(&(%{"name" => "repo#{&1}"}))
      "2" -> 101..200 |> Enum.map(&(%{"name" => "repo#{&1}"}))
      "3" -> 201..255 |> Enum.map(&(%{"name" => "repo#{&1}"}))
    end
  end

  defp get!("/repos/dwyl/tudo/issues?labels=help%20wanted") do
    [%{"title" => "Issue title",
      "labels" => [%{"name" => "help wanted",
                     "color" => "159818",
                     "default" => true}],
      "state" => "open",
      "html_url" => "https://github.com/dwyl/tudo/issues/1",
      "assignees" => [%{"login" => "shouston3",
                        "avatar_url" => "https://github.com/shouston3"}],
      "comments" => 1,
      "created_at" => "2011-04-22T13:33:48Z",
      "updated_at" => "2011-04-22T13:33:48Z"
    }]
  end

  defp get!("/repos/dwyl/tudo/hooks") do
    [%{"name" => "web",
       "id" => 1,
       "config" => %{"url" => "http://myapp.com/api/hooks"}}]
  end

  defp post!("/", "{\"key\":\"val\"}"), do: %{"method" => "post", "key" => "val"}
  defp post!("/repos/dwyl/tudo/hooks", "{\"name\":\"web\",\"events\":[\"issues\",\"issue_comment\"],\"config\":{\"url\":\"http://myapp.com/api/hooks\",\"content_type\":\"json\"},\"active\":true}") do
    [%{"name" => "web", "config" => %{"url" => "http://myapp.com/api/hooks"}}]
  end

  defp delete!("/"), do: %{"method" => "delete"}
  # actually responds with 204 status code
  # https://developer.github.com/v3/repos/hooks/#delete-a-hook
  defp delete!("/repos/dwyl/tudo/hooks/1"), do: %{"message" => "deleted"}
end
