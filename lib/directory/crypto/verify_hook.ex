defmodule Directory.Crypto.VerifyHook do
  @moduledoc """
  Verify JWT Token hook

  See elixirforum thread [19728](https://elixirforum.com/t/using-joken-to-validate-google-jwts/19728) on
  how to convert an external PEM or JWK into a Joken.Signer
  """

  use Joken.Hooks
  require Logger
  alias Google.Oauth2.Client

  @impl true
  def before_verify(_options, {jwt, %Joken.Signer{} = _signer}) do
    with {:ok, %{"kid" => kid}} <- Joken.peek_header(jwt),
         {:ok, algorithm, key} <- Client.find_certificate(kid) do
      {:cont, {jwt, Joken.Signer.create(algorithm, key)}}
    else
      error ->
        Logger.error("Error during verify hook. Error: " <> inspect(error))
        {:halt, {:error, :no_signer}}
    end
  end
end
