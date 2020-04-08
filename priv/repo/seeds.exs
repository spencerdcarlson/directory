# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Directory.Repo.insert!(%Directory.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Directory.{GoogleAuthInfo, Repo, User}

%User{
  auth_info: %GoogleAuthInfo{
    description: nil,
    email: "spencerdcarlson@gmail.com",
    expires_at: ~U[2020-04-07 00:10:11Z],
    first_name: "Spencer",
    id: 1,
    image: "https://lh3.googleusercontent.com/a-/AOh14Gh1lZOL3W31sfChqsQ52rpzu-hxZ_54uNuvOAsvC6g",
    inserted_at: ~N[2020-04-06 23:10:12],
    last_name: "Carlson",
    location: nil,
    name: "Spencer Carlson",
    nickname: nil,
    phone: nil,
    profile_url: nil,
    refresh_token:
      "1//0fS63SaI2ZXNdCgYIARAAGA8SNwF-L9IrDuHHzuVYebePIl4DCnAsvUwa2gBQAhmt8EDo3BwAd9fh4Yk37RHT9tiZ5xuDjsaINKQ",
    scopes:
      "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid",
    sub: "117904459812641885017",
    token:
      "ya29.a0Ae4lvC1z-LMr04QcqUEaROPd2f4TtTsHhwMUgjByOoWHlYWfq39B5GrUw7FYhOs9FeG1izU7UMuxQkp1DisJSyVgCGm0a9eaQDNRXgci-9O3sfFO3kgaaPwEoeQg2MDQgIqj1demdlY3ouef8lmfqgWZMnqyRkJ7FJ8",
    uid: "117904459812641885017",
    updated_at: ~N[2020-04-06 23:10:12],
    user_id: 1,
    website_url: nil
  },
  id: 1,
  inserted_at: ~N[2020-04-06 23:10:12],
  updated_at: ~N[2020-04-06 23:10:12]
}
|> Repo.insert!()
