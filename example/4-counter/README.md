# `4-counter`

<br>

This example shows how easy it is to define a custom middleware,
`count_requests`. It exposes the request count at
[http://localhost:8080/](http://localhost:8080/) in a sort of dashboard:

```ocaml
let count = ref 0

let count_requests inner_handler request =
  count := !count + 1;
  inner_handler request

let () =
  Dream.run
  @@ Dream.logger
  @@ count_requests
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.respond (Printf.sprintf "Saw %i request(s)!" !count));
  ]
  @@ Dream.not_found
```
<pre><code><b>$ dune exec --root . ./counter.exe</b></code></pre>

<br>

As you can see, defining middlewares in Dream is completely trivial! They are
[just functions](https://aantron.github.io/dream/#type-middleware) that take an
`inner_handler` as a parameter, and wrap it. They act like handlers themselves,
which means they usually also
[take a `request`](https://aantron.github.io/dream/#type-handler).

This example's middleware only does something *before* calling the
`inner_handler`. To do something *after*, we will need to await the response
promise with [Lwt](https://github.com/ocsigen/lwt#readme), the promise library
used by Dream. The next example, [**`5-promise`**](../5-promise#files), does
exactly that!

<!-- TODO
<br>

Advanced example [**`w-globals`**](../w-globals/#files) shows how to replace
global state like `count` by state scoped to the application. This is useful if
you are writing middleware to publish in a library. It's fine to use a global
`ref` in private code!
-->
<br>

**Next steps:**

- [**`5-promise`**](../5-promise#files) shows a middleware that awaits
  responses using [Lwt](https://github.com/ocsigen/lwt).
- [**`6-echo`**](../6-echo#files) responds to `POST` requests and reads their
  bodies.

<br>

[Up to the tutorial index](../#readme)
