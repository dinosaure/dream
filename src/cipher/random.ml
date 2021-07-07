(* This file is part of Dream, released under the MIT license. See LICENSE.md
   for details, or visit https://github.com/aantron/dream.

   Copyright 2021 Anton Bachin *)



(* TODO LATER Is there something with lighter dependencies? Although perhaps
   these are not so bad... *)

let _initialized = ref None

let initialized () =
  match !_initialized with
  | None -> failwith "Entropy is not initialized."
  | Some v -> Lazy.force v

let initialize f =
  ( try
      initialized () ;
    with
      Failure _ -> ());
  _initialized := Some (Lazy.from_fun f)

let random_buffer n =
  initialized () ;
  Mirage_crypto_rng.generate n

let random n =
  Cstruct.to_string (random_buffer n)
