defmodule Tudo.UserFromAuth do

  def basic_info(auth) do
    id = Map.get auth, :uid
    info = Map.get auth, :info, %{}
    avatar = Map.get info, :image

    %{id: id, name: name_from_info(info), avatar: avatar}
  end

  defp name_from_info(info) do
    case info do
      %{name: name} when not is_nil(name) and name != "" ->
        name
    _ ->
      name = [info.first_name, info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> Map.get info, :nickname
        true -> Enum.join(name, " ")
      end
    end
  end

end
