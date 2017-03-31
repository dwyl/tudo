defmodule Tudo.Github do
  use Tudo.Web, :controller
  use HTTPoison.Base
  alias Tudo.Github

  @endpoint "https://api.github.com"

  def process_url(url) do
    @endpoint <> url <> "?access_token=access_token here"
  end

  def index(repo) do
    Github.get("/repos/dwyl/" <> repo <> "/issues")
  end

end
