defmodule Tinvestex.Api.Sandbox do
  @prefix_url "sandbox"

  def request(adapter, path, body \\ %{}, params \\ %{}) do
    case sandbox_api_map(path) do
      nil ->
        {:error, "No route found for #{path} in trading api"}

      _ ->
        process_request(adapter, body, sandbox_api_map(path), params)
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

  def sandbox_api_map(path) do
    %{
      "register" => %{
        "url" => "#{@prefix_url}/sandbox/register",
        "method" => "post",
        "default_body" => %{"brokerAccountType" => "Tinkoff"}
      },
      "remove" => %{
        "url" => "#{@prefix_url}/sandbox/remove",
        "method" => "post"
      },
      "clear" => %{
        "url" => "#{@prefix_url}/sandbox/clear",
        "method" => "post"
      },
      "set_currency_balance" => %{
        "url" => "#{@prefix_url}/sandbox/currencies/balance",
        "method" => "post"
      }
    }[path]
  end
end
