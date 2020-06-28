defmodule Tinvestex do
  @moduledoc """
  Tinkoff Investments Elixir API Client.
  """

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_, _) do
    children = [
      {Registry, keys: :unique, name: Tinvestex.ProcessRegistry},
      {Tinvestex.Http, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
