defmodule Google.Oauth2.CertificateCache do
  @moduledoc """
  Agent to hold the current public certs that google uses to sign JWTs
  """

  use Agent
  require Logger
  alias Google.Oauth2.Certificates
  alias Google.Oauth2.Client

  @default_certificate_version 3

  def start_link([]) do
    %Certificates{}
    |> Certificates.set_version(@default_certificate_version)
    |> start_link()
  end

  def start_link(certs = %Certificates{}) do
    Agent.start_link(fn -> Client.certificates(certs) end, name: __MODULE__)
  end

  def get, do: Agent.get(__MODULE__, & &1) |> Client.certificates()
end
