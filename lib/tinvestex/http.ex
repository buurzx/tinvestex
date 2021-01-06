defmodule Tinvestex.Http do
  require Logger

  use GenServer

  @base_url "https://api-invest.tinkoff.ru/openapi"
  @throttle 1000

  @expected_fields ~w(
    status payload trackingId
  )

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: via_tuple(to_string(__MODULE__)))
  end

  def init(state) do
    {:ok, state}
  end

  def get(path, params) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)
    GenServer.call(__MODULE__, {:get, path, params})
  end

  def post({path, post_body, params}) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)
    GenServer.call(__MODULE__, {:post, path, post_body, params})
  end

  def handle_call({:get, path, params}, _from, state) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)
    # IO.inspect(DateTime.now!("Etc/UTC"), label: "Time NOW")
    # IO.puts("=================")

    response =
      case HTTPoison.get(url(path), headers(), params: params) do
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
          {:ok, handle_response(response_body)}

        {:ok, %HTTPoison.Response{status_code: 400, body: response_body}} ->
          error =
            Map.new(handle_response(response_body)["payload"], fn {key, value} ->
              {String.to_atom(key), value}
            end)

          struct(Tinvestex.Error, error)

          {:error, struct(Tinvestex.Error, error)}

        {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
          error =
            Map.new(handle_response(response_body)["payload"], fn {key, value} ->
              {String.to_atom(key), value}
            end)

          struct(Tinvestex.Error, error)

          {:error, struct(Tinvestex.Error, error)}

        errors ->
          errors
      end

    {:reply, response, state}
  end

  def handle_call({:post, path, body, params}, _from, state) do
    # default limit of 2 calls per second
    Process.sleep(@throttle)

    response =
      case HTTPoison.post(url(path), Jason.encode!(body), headers(), params: params) do
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
          {:ok, handle_response(response_body)}

        {:ok, %HTTPoison.Response{status_code: 500, body: response_body}} ->
          {:error, handle_response(response_body)}

        {:ok, %HTTPoison.Response{status_code: 400, body: response_body}} ->
          {:error, handle_response(response_body)}

        {:ok, %HTTPoison.Response{status_code: 401, body: response_body}} ->
          {:error, handle_response(response_body)}

        {:error, errors} ->
          %HTTPoison.Error{id: _, reason: reason} = errors
          # TODO: think about it
          if logging(),
            do: Logger.error("Http POST request #{path} failed, reason: #{IO.inspect(reason)}")

          {:error, errors}
      end

    {:reply, response, state}
  end

  # Helper Functions
  @spec handle_response(any) :: map
  defp handle_response(response_body) do
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

  defp logging do
    !is_nil(Application.get_env(:tinvestex, :log))
  end

  defp token do
    Application.get_env(:tinvestex, :token)
  end

  def adapter_pid(adapter_name) do
    adapter_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def via_tuple(name) do
    {:via, Registry, {Tinvestex.ProcessRegistry, name}}
  end
end
