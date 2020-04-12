# Directory
Example Phoenix microservice that authenticates a user using Google's oauth2 flow.

This application allows authentication via phoenix's session mechanisms as well as a Google issued JWT. Appropriate endpoints are protected against CSRF attacks.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start postgres database (see below if you want to use docker)
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`http://localhost:4000/auth/google`](http://localhost:4000/auth/google) from your browser.

If oauth flow is successful:
* User is redirected to `Application.get_env(:directory, :redirect_url)` which defaults to [localhost:8080]("http://localhost:8080")
* A session cookie will be set `_directory_key` (containing the user's id, and uid)
* An `id_token` cookie with Google issued JWT as the value is set

There are four endpoints to demonstrate authentication. 
* GET [/api/ds/session/whoami](localhost:8080/api/ds/session/whoami) - looks up a user from the session (`_directory_key` cookie)
* GET [/api/ds/jwt/whoami](localhost:8080/api/ds/jwt/whoami) - looks up a user form the Google issued jwt (`id_token` cookie)
* GET [/api/ds/csrf](localhost:8080/api/ds/csrf) - returns a CSRF token that can be used on protected requests.
* POST [/api/ds/logout](localhost:8080/api/ds/logout) - logout a user, requires a CSRF token to be sent in [header or params](https://hexdocs.pm/plug/Plug.CSRFProtection.html)

 
Curious if exposing an API endpoint to retrieve a CSRF token is dangerous? - See my writeup [here](https://www.notion.so/lsltr/A-CORS-Endpoint-ee305f7cfb0645b09d7cda18aaf586b0)

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Database
```bash
docker run --rm \
 -e POSTGRES_HOST_AUTH_METHOD=trust \
 -p 5432:5432 \
 --name postgres \
 postgres:latest
```  
* default username is postgres
* default password is postgres

#### Connect to database using PSQL
```bash
mix ecto.setup && \
docker exec -it postgres psql -U postgres -d directory_dev
directory_dev=#
```
