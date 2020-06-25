defmodule Tinvestex.Api do
  @adapter Tinvestex.Http

  alias Tinvestex.Api.{Trading, Sandbox}

  @spec trading(String.t(), map(), map()) :: {:error, any} | {:ok, map}
  def trading(command, params \\ %{}, body \\ %{}) do
    Trading.request(@adapter, command, body, params)
  end

  @spec sandbox(String.t(), map(), map()) :: {:error, any} | {:ok, map}
  def sandbox(command, params \\ %{}, body \\ %{}) do
    Sandbox.request(@adapter, command, body, params)
  end

  # Sandbox

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_register
  ---

  """
  @spec sandbox_register() :: {:ok, map} | {:error, any}
  def sandbox_register, do: sandbox("register")

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_remove
  ---

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  @spec sandbox_remove(map) :: {:ok, map} | {:error, any}
  def sandbox_remove(params), do: sandbox("remove", params)

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/sandbox/post_sandbox_clear
  ---

  params:
    %{
      brokerAccountId: String.t()
    }
  """
  @spec sandbox_clear(map) :: {:ok, map} | {:error, any}
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
  @spec sandbox_set_currency_balance(map, map) :: {:ok, map} | {:error, any}
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
  @spec sandbox_set_figi_balance(map, map) :: {:ok, map} | {:error, any}
  def sandbox_set_figi_balance(body, params) do
    sandbox("set_figi_balance", params, body)
  end

  # Trading

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/user/get_user_accounts
  ---
  """
  @spec accounts(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec orders(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec set_limit_order(map, map, boolean) :: {:ok, map} | {:error, any}
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
      figi: String.t()
      brokerAccountId: String.t()
    }

  body:
    %{
      "lots": 0,
      "operation": "Buy"
    }
  """
  @spec set_market_order(String.t(), String.t(), pos_integer(), boolean) ::
          {:ok, map} | {:error, any}
  def set_market_order(figi, brokerAccountId, lots, sandbox \\ false) do
    # def set_market_order(params, body, sandbox \\ false) do
    if sandbox,
      do:
        sandbox("set_market_order", %{figi: figi, brokerAccountId: brokerAccountId}, %{
          lots: lots,
          operation: "Buy"
        }),
      else:
        trading("set_market_order", %{figi: figi, brokerAccountId: brokerAccountId}, %{
          lots: lots,
          operation: "Buy"
        })
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/portfolio/get_portfolio
  ---

  params:
    %{
      brokerAccountId: string
    }
  """
  @spec portfolio(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec portfolio_currencies(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec operations(map, boolean) :: {:ok, map} | {:error, any}
  def operations(params, sandbox \\ false) do
    if sandbox, do: sandbox("operations", params), else: trading("operations", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_stocks
  ---
  """
  @spec stocks(boolean) :: {:ok, map} | {:error, any}
  def stocks(sandbox \\ false) do
    if sandbox, do: sandbox("stocks"), else: trading("stocks")
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_bonds
  ---
  """
  @spec bonds(map, boolean) :: {:ok, map} | {:error, any}
  def bonds(params, sandbox \\ false) do
    if sandbox, do: sandbox("bonds", params), else: trading("bonds", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_etfs
  ---
  """
  @spec etfs(map, boolean) :: {:ok, map} | {:error, any}
  def etfs(params, sandbox \\ false) do
    if sandbox, do: sandbox("etfs", params), else: trading("etfs", params)
  end

  @doc """
  https://tinkoffcreditsystems.github.io/invest-openapi/swagger-ui/#/market/get_market_currencies
  ---
  """
  @spec currencies(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec orderbook(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec candles(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec search_by_figi(map, boolean) :: {:ok, map} | {:error, any}
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
  @spec search_by_ticker(map, boolean) :: {:ok, map} | {:error, any}
  def search_by_ticker(params, sandbox \\ false) do
    if sandbox, do: sandbox("search_by_ticker", params), else: trading("search_by_ticker", params)
  end
end
