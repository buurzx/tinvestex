defmodule Tinvestex.Api do
  @adapter Tinvestex.Http

  alias Tinvestex.Api.{Trading, Sandbox}

  def trading(command, body \\ %{}, params \\ %{}) do
    Trading.request(@adapter, command, body, params)
  end

  def sandbox(command, body \\ %{}, params \\ %{}) do
    Sandbox.request(@adapter, command, body, params)
  end

  def sandbox_register, do: sandbox("register")
  def sandbox_remove, do: sandbox("remove")
  def sandbox_clear, do: sandbox("clear")

  @doc """
  brokerAccountId: string
  body:
  {
    "currency": "RUB",
    "balance": 0
  }
  """
  def sandbox_set_currency_balance(body, params) do
    sandbox("set_currency_balance", body, params)
  end
end
