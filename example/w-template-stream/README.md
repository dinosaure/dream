# `w-template-stream`

<br>

This example [streams](https://aantron.github.io/dream/#streaming) a template as
a response body. It sends one paragraph per second to the client:

```ocaml
let render response =
  let%lwt () =
    %% response
    <html>
      <body>
%       let rec paragraphs index =
          <p><%i index %></p>
%         let%lwt () = Dream.flush response in
%         let%lwt () = Lwt_unix.sleep 1. in
%         paragraphs (index + 1)
%       in
%       let%lwt () = paragraphs 0 in
      </body>
    </html>
  in
  Dream.close_stream response

let () =
  Dream.run
  @@ Dream.logger
  @@ fun _ -> Dream.stream render
```

<pre><code><b>$ dune exec --root . ./template_stream.exe</b></code></pre>

<br>

Most uses of streaming don't need
[`Dream.flush`](https://aantron.github.io/dream/#val-flush), but we are using it
here to prevent buffering of each paragraph.

<br>

**See also:**

- [**`7-template`**](../7-template#security) section *Security* on security
  considerations with templates, and in general.
- [**`r-template-stream`**](../r-template-stream#files) is a Reason syntax
  version of this example.

<br>

[Up to the example index](../#examples)

<!-- TODO OWASP link; injection general link. -->
<!-- TODO Link to template syntax reference. -->
