defmodule Tinvestex.Http do
  require Logger

  @base_url "https://api-invest.tinkoff.ru/openapi"
  @throttle 1000

  @expected_fields ~w(
    status payload trackingId
  )

  def get(path, params) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)

    case HTTPoison.get(url(path), headers(), params: params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, handle_ok(response_body)}

      {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
        {:error, handle_server_error(response_body)}

      errors ->
        errors
    end
  end

  def post(path, body, params \\ []) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)

    param_pairs =
      Enum.map(params, fn {key, value} ->
        "#{key}=#{value}"
      end)

    case HTTPoison.post(url(path), Jason.encode!(body), headers(), param_pairs) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, handle_ok(response_body)}

      {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
        {:error, handle_server_error(response_body)}

      {:error, errors} ->
        %HTTPoison.Error{id: _, reason: reason} = errors

        if logging(),
          do: Logger.error("Http POST request #{path} failed, reason: #{IO.inspect(reason)}")

        {:error, errors}
    end
  end

  # Helper Functions

  defp handle_ok(response_body) do
    response_body
    |> Jason.decode!()
    |> Map.take(@expected_fields)
  end

  def handle_server_error(response_body) do
    response_body
    |> Jason.decode!()
    |> Map.take(@expected_fields)
  end

  defp headers do
    [
      {"content-type", "application/json"},
      {"Authorization", "Bearer #{token()}"}
    ]
  end

  defp url(path) do
    "#{@base_url}/#{path}"
  end

  def logging do
    !is_nil(Application.get_env(:tinvestex, :log))
  end

  defp token do
    Application.get_env(:tinvestex, :token)
  end
end
