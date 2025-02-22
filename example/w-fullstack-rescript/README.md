# `w-fullstack-rescript`

<br>

This example shares a toy function between client and server using
[ReScript](https://rescript-lang.org/). The function is in
[common/common.ml](https://github.com/aantron/dream/blob/master/example/w-fullstack-rescript/common/common.ml).
It's in OCaml syntax because the ReScript syntax is not available for the server
side:

```ocaml
let greet = function
  | `Server -> "Hello..."
  | `Client -> "...world!"
```

As you can probably guess, we are going to print the first part of the message
on the server,
[server/server.eml.ml](https://github.com/aantron/dream/blob/master/example/w-fullstack-rescript/server/server.eml.ml):

```ocaml
let home =
  <html>
    <body>
      <p><%s Common.greet `Server %></p>
      <script src="/static/client.js"></script>
    </body>
  </html>

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [

    Dream.get "/"
      (fun _ -> Dream.respond home);

    Dream.get "/static/*"
      (Dream.static "./static");

  ]
  @@ Dream.not_found
```

...and the rest of the message in the client,
[client/client.res](https://github.com/aantron/dream/blob/master/example/w-fullstack-rescript/client/client.res):

```rescript
open Webapi.Dom;

let () = {
  let body = document |> Document.querySelector("body");

  switch (body) {
  | None => ();
  | Some(body) =>

    let text = Common.greet(#Client);

    let p = document |> Document.createElement("p");
    p->Element.setInnerText(text);
    body |> Element.appendChild(p);
  };
};
```

To run the whole thing, do

<pre><code><b>npm install
npm run start
</b></code></pre>

Then visit [http://localhost:8080](http://localhost:8080), and you will see...

![Full-stack greeting](https://raw.githubusercontent.com/aantron/dream/master/docs/asset/fullstack.png)

<br>

Besides ReScript and Dream, this example also uses
[bs-webapi](https://github.com/reasonml-community/bs-webapi-incubator#readme)
for DOM manipulation, and [esbuild](https://esbuild.github.io/) for bundling the
client in `./static/client.js`. The example serves the bundled client using
[`Dream.static`](https://aantron.github.io/dream/#val-static).

<br>

**See also:**

- [**`f-static`**](../r-hello#files) presents
  [`Dream.static`](https://aantron.github.io/dream/#val-static).

<br>

[Up to the example index](../#examples)
