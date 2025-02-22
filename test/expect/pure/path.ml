(* This file is part of Dream, released under the MIT license. See
   LICENSE.md for details, or visit https://github.com/aantron/dream.

   Copyright 2021 Anton Bachin *)



let decode string =
  string
  |> Dream.from_target_path
  |> List.map (Printf.sprintf "%S")
  |> String.concat " "
  |> Printf.printf "[%s]\n"

let%expect_test _ =
  decode "";
  decode "/";
  decode "abc";
  decode "abc/";
  decode "/abc/";
  decode "//abc/";
  decode "a%2Fb";
  decode "a/b";
  decode "a//b";
  decode "%CE%BB";
  decode "/λ/λ";
  decode "/%Ce%bB";
  decode "/%c";
  decode "/%c/";
  decode "/%cg";
  decode "/%";
  decode "/%/";
  [%expect {|
    []
    [""]
    ["abc"]
    ["abc" ""]
    ["abc" ""]
    ["abc" ""]
    ["a/b"]
    ["a" "b"]
    ["a" "b"]
    ["\206\187"]
    ["\206\187" "\206\187"]
    ["\206\187"]
    ["%c"]
    ["%c" ""]
    ["%cg"]
    ["%"]
    ["%" ""] |}]

let drop path =
  path
  |> Dream.drop_empty_trailing_path_component
  |> List.map (Printf.sprintf "%S")
  |> String.concat " "
  |> Printf.printf "[%s]\n"

let%expect_test _ =
  drop ["a"];
  drop ["a"; ""];
  drop ["a"; "b"];
  drop ["a"; "b"; ""];
  [%expect {|
    ["a"]
    ["a"]
    ["a" "b"]
    ["a" "b"] |}]
