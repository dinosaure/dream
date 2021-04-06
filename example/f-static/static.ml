let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/static/*" (Dream.static ".")
  ]
  @@ Dream.not_found
