defmodule Tinvestex.Api.Trading do
  import Tinvestex.Api.Base

  @spec request(module(), String.t(), map, map) :: {:error, String.t() | any} | {:ok, map}
  def request(adapter, command, body \\ %{}, params \\ %{}) do
    case api_map(command) do
      nil ->
        {:error, "No route found for #{command} in trading api"}

      _ ->
        process_request(adapter, body, api_map(command), params)
    end
  end

  def process_request(adapter, body, route_params, params \\ %{}) do
    post_body =
      if body == %{} && !is_nil(route_params["default_body"]) do
        route_params["default_body"]
      else
        body
      end

    adapter_pid = adapter.adapter_pid(to_string(adapter))

    case route_params["method"] do
      "post" -> GenServer.call(adapter_pid, {:post, route_params["url"], post_body, params})
      "get" -> GenServer.call(adapter_pid, {:get, route_params["url"], params})
    end
  end

  defp api_map(command) do
    command_map()[command]
  end
end
