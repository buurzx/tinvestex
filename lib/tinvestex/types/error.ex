defmodule Tinvestex.Error do
  @typedoc """
  Defines a Error type

  * :code => "GATEWAY_REQUEST_DATA_ERROR",
  * : message => "Invalid token scopes"
  """
  @type t :: %Tinvestex.Error{
          code: String.t(),
          message: String.t()
        }
  defstruct code: "",
            message: ""
end
