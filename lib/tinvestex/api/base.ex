defmodule Tinvestex.Api.Base do
  def command_map do
    %{
      "accounts" => %{
        "url" => "/user/accounts",
        "method" => "get"
      },
      "orders" => %{
        "url" => "/orders",
        "method" => "get"
      },
      "set_limit_order" => %{
        "url" => "/orders/limit-order",
        "method" => "post"
      },
      "set_market_order" => %{
        "url" => "/orders/market-order",
        "method" => "post"
      },
      "cancel_order" => %{
        "url" => "/orders/cancel",
        "method" => "post"
      },
      "portfolio" => %{
        "url" => "/portfolio",
        "method" => "get"
      },
      "portfolio_currencies" => %{
        "url" => "/portfolio/currencies",
        "method" => "get"
      },
      "operations" => %{
        "url" => "/operations",
        "method" => "get"
      }
    }
  end
end
