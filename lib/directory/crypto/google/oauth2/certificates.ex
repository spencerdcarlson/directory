defmodule Google.Oauth2.Certificate do
  @moduledoc """
  Struct to tie a kid to a certificate
  kid is the id and cert can either be a map with a pem or a JWK map

  version 1 cert is %{"pem" => "-----BEGIN CERTIFICATE----- ..."}
  version 3 cert is %{"kid" => "53c66aab5...". "e" => "AQAB", ...}
  """
  defstruct kid: nil, cert: nil
end

defmodule Google.Oauth2.Certificates do
  @moduledoc """
  Struct that holds a list of Google.Oauth2.Certificate structs
  with their expiration time algorithm and version
  """

  alias Google.Oauth2.Certificate
  defstruct certs: [], expire: nil, algorithm: "RS256", version: 1

  def expired?(%__MODULE__{expire: expire}), do: expire < DateTime.utc_now()

  def set_expiration(struct = %__MODULE__{}, expiration) do
    %__MODULE__{struct | expire: expiration}
  end

  def set_version(struct = %__MODULE__{}, version) do
    %__MODULE__{struct | version: version}
  end

  def add_cert(struct = %__MODULE__{certs: certs, version: 1}, kid, cert) do
    %__MODULE__{
      struct
      | certs: [%Certificate{kid: kid, cert: %{"pem" => cert}} | certs]
    }
  end

  def add_cert(struct = %__MODULE__{certs: certs, version: 3}, kid, cert) do
    %__MODULE__{
      struct
      | certs: [%Certificate{kid: kid, cert: cert} | certs],
        algorithm: Map.get(cert, "alg")
    }
  end

  def find(%__MODULE__{certs: certs}, kid) do
    Enum.find(certs, fn %Certificate{kid: id} -> id == kid end)
  end
end
