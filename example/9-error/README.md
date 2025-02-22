# `9-error`

<br>

You can easily customize *all* error responses generated by Dream, whether from
your application, or at lower levels in the HTTP stack. This is done by passing
the `~error_handler` parameter to
[`Dream.run`](https://aantron.github.io/dream/#val-run). The easiest way to get
an `error_handler` is to call
[`Dream.error_template`](https://aantron.github.io/dream/#val-error_template):

```ocaml
let my_error_template debug_info suggested_response =
  let status = Dream.status suggested_response in
  let code = Dream.status_to_int status
  and reason = Dream.status_to_string status in

  suggested_response
  |> Dream.with_body begin
    <html>
      <body>
        <h1><%i code %> <%s reason %></h1>
%       begin match debug_info with
%       | None -> ()
%       | Some debug_info ->
          <pre><%s debug_info %></pre>
%       end;
      </body>
    </html>
  end
  |> Lwt.return

let () =
  Dream.run ~error_handler:(Dream.error_template my_error_template)
  @@ Dream.logger
  @@ Dream.not_found
```

<pre><code><b>$ dune exec --root . ./error.exe</b></code></pre>

<br>

We kept the error template simple for the sake of the example, but this is
where you'd put in neat graphics to make a beautiful error page!

This app doesn't show debug information by default. However, try adding
`~debug:true` to [`Dream.run`](https://aantron.github.io/dream/#val-run),
rebuilding the app, and accessing it again. You will see the same kind of output
as in example [**`8-debug`**](../8-debug#files), but now you control its
placement and styling.

<br>

Dream will call the error template for every single error response it generates:

1. `4xx` and `5xx` error responses returned by your application.
2. Exceptions raised by your application.
3. Whenever the lower-level HTTP servers want to send a response; for instance,
   a `400 Bad Request` due to malformed headers.

The `suggested_response` argument contains a skeleton response. It is either the
response returned by your application in case (1), an empty `500 Internal
Server Error` if your application raised an exception (2), or a `500 Internal
Server Error` or `400 Bad Request` suggested by the HTTP servers in response to
lower-level failures (3).

The easiest thing to do is to decorate `suggested_response` with a fancy
response body, and maybe add some headers. However, you can do anything here,
including return a completely new response.

<br>

`debug_info` is `None` by default. If you passed `~debug:true` to
[`Dream.run`](https://aantron.github.io/dream/#val-run), it is `Some` of a
string that contains the debug info that we saw in the previous example,
[**`8-debug`**](../8-debug#files).

<!-- TODO Images of the generated pages. -->

<br>

If you don't customize the error handler, Dream defaults to sending only empty
responses, so that your application can be fully localization-friendly &mdash;
even at the lowest levels.

<br>

**Next steps:**

- [**`a-log`**](../a-log#files) shows how to write messages to Dream's
  [log](https://aantron.github.io/dream/#logging).
- [**`b-session`**](../b-session#files) adds [session
  management](https://aantron.github.io/dream/#sessions) for associating state
  with clients.

<br>

[Up to the tutorial index](../#readme)
