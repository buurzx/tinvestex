defmodule Tinvestex.Api do
  @adapter Tinvestex.Http

  alias Tinvestex.Api.{Trading, Sandbox}

  def trading(command, params \\ %{}, body \\ %{}) do
    Trading.request(@adapter, command, body, params)
  end

  def sandbox(command, params \\ %{}, body \\ %{}) do
    Sandbox.request(@adapter, command, body, params)
  end

  # Sandbox

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_register
  ---

  """
  def sandbox_register, do: sandbox("register")

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_remove
  ---

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  def sandbox_remove(params), do: sandbox("remove", params)

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_clear
  ---

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  def sandbox_clear(params), do: sandbox("clear", params)

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_currencies_balance
  ---

  body:
    %{
      "currency": String.t(),
      "balance": float()
    },

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  def sandbox_set_currency_balance(body, params) do
    sandbox("set_currency_balance", params, body)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_positions_balance
  ---

  body:
    %{
      "figi": String.t(),
      "balance": float()
    }

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  def sandbox_set_figi_balance(body, params) do
    sandbox("set_figi_balance", params, body)
  end

  # Trading

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/user/get_user_accounts
  ---
  """
  def accounts(params, sandbox \\ false) do
    if sandbox, do: sandbox("accounts", params), else: trading("accounts", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/orders/get_orders
  ---

  params:
    %{
      brokerAccountId: string
    }
  """
  def orders(params, sandbox \\ false) do
    if sandbox, do: sandbox("orders", params), else: trading("orders", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/orders/post_orders_limit_order
  ---

  params:
    %{
      figi: string
      brokerAccountId: string
    }

  body:
    %{
      "lots": 0,
      "operation": "Buy",
      "price": 0
    }
  """
  def set_limit_order(params, body, sandbox \\ false) do
    if sandbox,
      do: sandbox("set_limit_order", params, body),
      else: trading("set_limit_order", params, body)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/orders/post_orders_cancel
  ---

  params:
    %{
      orderId: String.t()
      brokerAccountId: String.t()
    }
  """
  def set_market_order(params, body, sandbox \\ false) do
    if sandbox,
      do: sandbox("set_market_order", params, body),
      else: trading("set_market_order", params, body)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/portfolio/get_portfolio
  ---

  params:
    %{
      brokerAccountId: string
    }
  """
  def portfolio(params, sandbox \\ false) do
    if sandbox, do: sandbox("portfolio", params), else: trading("portfolio", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/portfolio/get_portfolio_currencies
  ---

  params:
    %{
      brokerAccountId: string
    }
  """
  def portfolio_currencies(params, sandbox \\ false) do
    if sandbox,
      do: sandbox("portfolio_currencies", params),
      else: trading("portfolio_currencies", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/operations/get_operations
  ---

  params:
    %{
      from: String.t() # 2019-08-19T18:38:33.131642+03:00
      to: String.t() # 2019-08-19T18:38:33.131642+03:00
      figi: String.t()
      brokerAccountId: String.t()
    }
  """
  def operations(params, sandbox \\ false) do
    if sandbox, do: sandbox("operations", params), else: trading("operations", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_stocks
  ---
  """
  def stocks(params, sandbox \\ false) do
    if sandbox, do: sandbox("stocks", params), else: trading("stocks", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_bonds
  ---
  """
  def bonds(params, sandbox \\ false) do
    if sandbox, do: sandbox("bonds", params), else: trading("bonds", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_etfs
  ---
  """
  def etfs(params, sandbox \\ false) do
    if sandbox, do: sandbox("etfs", params), else: trading("etfs", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_currencies
  ---
  """
  def currencies(params, sandbox \\ false) do
    if sandbox, do: sandbox("currencies", params), else: trading("currencies", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_orderbook
  ---

  params:
    %{
      figi: String.t(),
      depth: String.t()
    }
  """
  def orderbook(params, sandbox \\ false) do
    if sandbox, do: sandbox("orderbook", params), else: trading("orderbook", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_candles
  ---


  params:
    %{
      figi: String.t(),
      from: "2019-08-19T18:38:33.131642+03:00",
      to: "2019-08-19T18:38:33.131642+03:00",
      interval: "1min" # Available values : 1min, 2min, 3min, 5min, 10min, 15min, 30min, hour, day, week, month
    }
  """
  def candles(params, sandbox \\ false) do
    if sandbox, do: sandbox("candles", params), else: trading("candles", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_search_by_figi
  ---

  params:
    %{
      figi: String.t()
    }
  """
  def search_by_figi(params, sandbox \\ false) do
    if sandbox, do: sandbox("search_by_figi", params), else: trading("search_by_figi", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_search_by_ticker
  ---

  params:
    %{
      ticker: String.t()
    }
  """
  def search_by_ticker(params, sandbox \\ false) do
    if sandbox, do: sandbox("search_by_ticker", params), else: trading("search_by_ticker", params)
  end
end
