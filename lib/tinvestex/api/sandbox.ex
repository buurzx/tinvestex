defmodule Tinvestex.Api.Sandbox do
  import Tinvestex.Api.Base
  @prefix_url "sandbox"

  def request(adapter, command, body \\ %{}, params \\ %{}) do
    case sandbox_api_map(command) do
      nil ->
        {:error, "No route found for #{command} in trading api"}

      _ ->
        process_request(adapter, body, sandbox_api_map(command), params)
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
      "post" -> adapter.post("#{@prefix_url}/#{route_params["url"]}", post_body, params)
      "get" -> adapter.get("#{@prefix_url}/#{route_params["url"]}", params)
    end
  end

  def sandbox_api_map(command) do
    Map.merge(
      %{
        "register" => %{
          "url" => "sandbox/register",
          "method" => "post",
          "default_body" => %{"brokerAccountType" => "Tinkoff"}
        },
        "remove" => %{
          "url" => "sandbox/remove",
          "method" => "post"
        },
        "clear" => %{
          "url" => "sandbox/clear",
          "method" => "post"
        },
        "set_currency_balance" => %{
          "url" => "sandbox/currencies/balance",
          "method" => "post"
        }
      },
      command_map()
    )[command]
  end
end
