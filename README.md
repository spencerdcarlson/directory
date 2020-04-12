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
