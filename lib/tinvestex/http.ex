defmodule Tinvestex.Http do
  @base_url "https://api-invest.tinkoff.ru/openapi"
  @throttle 1000
  def get(path, command, params) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)

    headers = []
    merged_params = Map.merge(%{command: command}, params)

    case HTTPoison.get(url(path), headers, params: merged_params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        handle_ok(response_body)

      errors ->
        errors
    end
  end

  def post do
  end

  # Helper Functions

  defp handle_ok(response_body) do
    response_body
    |> Jason.decode()
    |> case do
      {:ok, %{"error" => message}} ->
        {:error, message}

      {:ok, %{"result" => %{"error" => message}, "success" => 0}} ->
        {:error, message}

      {:ok, body} ->
        {:ok, body}

      {:error, _} = error ->
        error
    end
  end

  defp url(path) do
    "#{@base_url}/#{path}"
  end

  defp token do
    Application.get_env(:tinvestex, :token)
  end
end
