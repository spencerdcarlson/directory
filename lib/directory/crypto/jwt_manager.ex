defmodule Directory.Crypto.JWTManager do
  @moduledoc """
  JWT Manager
  """

  use Joken.Config, default_signer: nil

  @iss "https://accounts.google.com"
  defp aud, do: Application.get_env(:directory, :google_client_id)

  add_hook(Directory.Crypto.VerifyHook)

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("iss", nil, &(&1 == @iss))
    |> add_claim("aud", nil, &(&1 == aud()))
  end
end
