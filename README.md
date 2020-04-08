# Directory

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Database
```bash
docker run --rm \
 -e POSTGRES_HOST_AUTH_METHOD=trust \
 -p 5432:5432 \
 --name postgres \
 postgres:latest
```

## Uberauth

```elxir
Auth Struct: %Ueberauth.Auth{
  credentials: %Ueberauth.Auth.Credentials{
    expires: true,
    expires_at: 1586219804,
    other: %{},
    refresh_token: "1//01u1Zkoc1pCsxCgYIARAAGAESNwF-L9IrHEGPq27Urgq1qPAQCIgQUddPh1xWnli2A7NVL59yBmYY7mGw0W21NrHkWTH1mVIJ-2g",
    scopes: ["https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid"],
    secret: nil,
    token: "ya29.a0Ae4lvC2EiXcnvP2g6ynuvEYS_2rSicLrvgGBk-zu1sKQ8YJn5jVEA0sSIfG9exNfgcAkVE_Q2J-J_NRV23BTs1mBmqiedW6-DUSCfSYBZpf_tgQgqbJkuXVgOnSuutxNbVQFXAj44BiG4cio0Y2lSZdulxtbOsVpG0c",
    token_type: "Bearer" 
  },
  extra: %Ueberauth.Auth.Extra{
    raw_info: %{
      token: %OAuth2.AccessToken{
        access_token: "ya29.a0Ae4lvC2EiXcnvP2g6ynuvEYS_2rSicLrvgGBk-zu1sKQ8YJn5jVEA0sSIfG9exNfgcAkVE_Q2J-J_NRV23BTs1mBmqiedW6-DUSCfSYBZpf_tgQgqbJkuXVgOnSuutxNbVQFXAj44BiG4cio0Y2lSZdulxtbOsVpG0c",
        expires_at: 1586219804,
        other_params: %{
          "id_token" => "eyJhbGciOiJSUzI1NiIsImtpZCI6IjI1N2Y2YTU4MjhkMWU0YTNhNmEwM2ZjZDFhMjQ2MWRiOTU5M2U2MjQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2MDY1NjU3NjAwMS1zOXNyazFsa2hnOWRtYmdtNjFhZnNhYjQ3c2dyczkyOC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6IjYwNjU2NTc2MDAxLXM5c3JrMWxraGc5ZG1iZ202MWFmc2FiNDdzZ3JzOTI4LmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTE3OTA0NDU5ODEyNjQxODg1MDE3IiwiZW1haWwiOiJzcGVuY2VyZGNhcmxzb25AZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJOazF5WjB0el9ZcDlLQ1VMeC1XcG1RIiwibmFtZSI6IlNwZW5jZXIgQ2FybHNvbiIsInBpY3R1cmUiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS0vQU9oMTRHaDFsWk9MM1czMXNmQ2hxc1E1MnJwenUtaHhaXzU0dU51dk9Bc3ZDNmc9czk2LWMiLCJnaXZlbl9uYW1lIjoiU3BlbmNlciIsImZhbWlseV9uYW1lIjoiQ2FybHNvbiIsImxvY2FsZSI6ImVuIiwiaWF0IjoxNTg2MjE2MjA1LCJleHAiOjE1ODYyMTk4MDV9.EwmBGB-ZKiX6aaCaOnwj4FYbE_VIke77tElOTOkpk34RhwjmcfkliJyEW-M5ZR7ShKdLCJp1m_7n0TzP6cjFYdE6krfclMflmXzgy_312H6zWsMKyUv7KAQGIaQAcz4Gt_IZpLaueuyA9HRtOZt0qhBxjc_Wv_QG0Klc-Ljelg8LUnNu1i1Rr2nbYQwsQfEa3zoamldIKl7GXJVm0FQEuaJ6eIdvVU0tddsfK8bEYsINTUFbkcz8LldJ3ue3slgx7eAJ06SGBVtsEbZqvpSD1ciJ7bjOikDzQ4_OTVVYHfmc3vwZFU_Po_Ils_cUX8pWpf4nwFiqcrCLUj6lSY6uqg",
          "scope" => "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid"
        },
        refresh_token: "1//01u1Zkoc1pCsxCgYIARAAGAESNwF-L9IrHEGPq27Urgq1qPAQCIgQUddPh1xWnli2A7NVL59yBmYY7mGw0W21NrHkWTH1mVIJ-2g",
        token_type: "Bearer"
      },
      user: %{
        "email" => "spencerdcarlson@gmail.com",
        "email_verified" => true,
        "family_name" => "Carlson",
        "given_name" => "Spencer",
        "locale" => "en",
        "name" => "Spencer Carlson",
        "picture" => "https://lh3.googleusercontent.com/a-/AOh14Gh1lZOL3W31sfChqsQ52rpzu-hxZ_54uNuvOAsvC6g",
        "sub" => "117904459812641885017"
      }
    }
  },
  info: %Ueberauth.Auth.Info{
    description: nil,
    email: "spencerdcarlson@gmail.com",
    first_name: "Spencer",
    image: "https://lh3.googleusercontent.com/a-/AOh14Gh1lZOL3W31sfChqsQ52rpzu-hxZ_54uNuvOAsvC6g",
    last_name: "Carlson",
    location: nil,
    name: "Spencer Carlson",
    nickname: nil,
    phone: nil,
    urls: %{profile: nil, website: nil}
  },
  provider: :google,
  strategy: Ueberauth.Strategy.Google,
  uid: "117904459812641885017"
}
```
