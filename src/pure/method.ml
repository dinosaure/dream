(* This file is part of Dream, released under the MIT license. See
   LICENSE.md for details, or visit https://github.com/aantron/dream.

   Copyright 2021 Anton Bachin *)



type method_ = [
  | `GET
  | `POST
  | `PUT
  | `DELETE
  | `HEAD
  | `CONNECT
  | `OPTIONS
  | `TRACE
  | `PATCH
  | `Method of string
]

let method_to_string = function
  | `GET -> "GET"
  | `POST -> "POST"
  | `PUT -> "PUT"
  | `DELETE -> "DELETE"
  | `HEAD -> "HEAD"
  | `CONNECT -> "CONNECT"
  | `OPTIONS -> "OPTIONS"
  | `TRACE -> "TRACE"
  | `PATCH -> "PATCH"
  | `Method method_ -> method_

let string_to_method = function
  | "GET" -> `GET
  | "POST" -> `POST
  | "PUT" -> `PUT
  | "DELETE" -> `DELETE
  | "HEAD" -> `HEAD
  | "CONNECT" -> `CONNECT
  | "OPTIONS" -> `OPTIONS
  | "TRACE" -> `TRACE
  | "PATCH" -> `PATCH
  | method_ -> `Method method_

(* TODO Test this. *)
(* TODO Technically, this does one allocation in case the string can't be
   converted to a variant, which can be saved by inlining string_to_method.
   However, this is probably extremely rare. *)
let normalize_method = function
  | `Method method_ -> string_to_method method_
  | method_ -> method_

let methods_equal method_1 method_2 =
  normalize_method method_1 = normalize_method method_2
