defmodule Tinvestex.Api.Trading do
  def request(adapter, path, body \\ %{}, params \\ %{}) do
    case api_map(path) do
      nil ->
        {:error, "No route found for #{path} in trading api"}

      _ ->
        process_request(adapter, body, api_map(path), params)
    end
  end

  def process_request(adapter, body, route_params, params \\ %{}) do
    post_body =
      if body == %{} && !is_nil(route_params["default_body"]) do
        route_params["default_body"]
      else
        body
      end

    case route_params["method"] do
      "post" -> adapter.post(route_params["url"], post_body, params)
      "get" -> adapter.get(route_params["url"], params)
    end
  end

  defp api_map(path) do
    %{}
  end
end
