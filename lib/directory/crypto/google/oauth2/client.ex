defmodule Google.Oauth2.Client do
  @moduledoc """
  Google Oauth 2 Client
  Google's documentation: https://developers.google.com/identity/sign-in/web/backend-auth
  """

  require Logger
  alias Google.Oauth2.CertificateCache
  alias Google.Oauth2.Certificates

  def find_certificate(kid) do
    certificates = %Certificates{algorithm: algorithm} = CertificateCache.get()

    case Certificates.find(certificates, kid) do
      %Google.Oauth2.Certificate{cert: cert} -> {:ok, algorithm, cert}
      nil -> {:error, :cert_not_found}
      _ -> {:error, :cert_not_found}
    end
  end

  def certificates(certs = %Certificates{version: version}) do
    if Certificates.expired?(certs) do
      Logger.debug("Certificates are expired. Make HTTP call")

      with {:ok, path} <- certificate_uri_path(version),
           {:ok, 200, headers, response} <-
             :hackney.get("https://www.googleapis.com" <> path, [
               {"content-type", "application/json"}
             ]),
           {:ok, seconds} <- max_age(headers),
           {:ok, expiration} <- expiration(seconds),
           {:ok, body} <- :hackney.body(response),
           {:ok, decoded} <- Jason.decode(body) do
        %Certificates{}
        |> Certificates.set_version(version)
        |> Certificates.set_expiration(expiration)
        |> map_certificates(decoded)
      else
        error ->
          Logger.error("Error getting Google OAuth2 certificates. Error: " <> inspect(error))
          certs
      end
    else
      Logger.debug("Certificates are not expired. Using cache")
      certs
    end
  end

  def certificates(_), do: certificates(%Certificates{})

  defp map_certificates(certs = %Certificates{version: 1}, body) do
    Enum.reduce(body, certs, fn {kid, cert}, acc ->
      Certificates.add_cert(acc, kid, cert)
    end)
  end

  defp map_certificates(certs = %Certificates{version: 3}, body) do
    body
    |> Map.get("keys")
    |> Enum.reduce(certs, fn cert = %{"kid" => kid}, acc ->
      Certificates.add_cert(acc, kid, cert)
    end)
  end

  defp certificate_uri_path(1), do: {:ok, "/oauth2/v1/certs"}
  defp certificate_uri_path(3), do: {:ok, "/oauth2/v3/certs"}
  defp certificate_uri_path(_), do: {:error, :no_cert_version_path}

  defp max_age(headers) do
    with {_, value} <-
           Enum.find(headers, :cache_contro_not_found, fn {key, _} ->
             Regex.match?(~r/cache-control/i, key)
           end),
         %{"max_age" => seconds} <- Regex.named_captures(~r/.*max-age=(?<max_age>\d+)/, value) do
      {:ok, String.to_integer(seconds)}
    else
      error ->
        Logger.error("error getting max age from response headers. Error: " <> inspect(error))
        {:error, :no_max_age}
    end
  end

  defp expiration(seconds) when is_number(seconds) do
    {:ok, DateTime.add(DateTime.utc_now(), seconds, :second)}
  end

  defp expiration(_), do: {:error, :expiration}
end
