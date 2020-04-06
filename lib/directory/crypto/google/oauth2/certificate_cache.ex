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
    case load() do
      {:ok, certs = %Certificates{}} ->
        start_link(certs)

      _ ->
        %Certificates{}
        |> Certificates.set_version(@default_certificate_version)
        |> start_link()
    end
  end

  def start_link(certs = %Certificates{}) do
    Agent.start_link(
      fn ->
        certs |> Client.certificates() |> serialize()
      end,
      name: __MODULE__
    )
  end

  def get, do: Agent.get(__MODULE__, & &1) |> Client.certificates()

  defp load do
    with true <- File.exists?(path()),
         {:ok, json} <- File.read(path()),
         {:ok, certs} <- Certificates.decode(json) do
      Logger.debug("Certificates were loaded from disk.")
      {:ok, certs}
    else
      error ->
        Logger.error("Error loading certs from file. Error: " <> inspect(error))
        {:error, :load_certificates}
    end
  end

  defp serialize(certs = %Certificates{}) do
    with {:ok, file} <- File.open(path(), [:write]),
         {:ok, json} <- Jason.encode(certs),
         :ok <- IO.binwrite(file, json) do
      Logger.debug("Saved certificates. location: #{inspect(path())}")
      certs
    else
      error ->
        Logger.error("error serializing certificates. Error: " <> inspect(error))
        certs
    end
  end

  defp path do
    case :application.get_application() do
      {:ok, app} ->
        app
        |> :code.priv_dir()
        |> Path.join("google.oauth2.certificates.json")

      _ ->
        "/tmp/google.oauth2.certificates.json"
    end
  end
end
