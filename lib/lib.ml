(* open Base *)
open Sexplib.Std

module Sexp = Sexplib.Sexp

type t = { foo: int; bar: float } [@@deriving sexp]

let rec fib n =
	if n < 2 then 1
	else fib (n - 1) + fib (n - 2)

let format_result n =
	Printf.sprintf "Result is: %d\n" n

let test_threads n =
	let t = Thread.create
		(fun () ->
			let result = format_result (fib n) in
			Logs.debug (fun m -> m "Message from thread: %s" result))
		()
	in
	Thread.id t
	|> Int.to_string
	|> Cocoa.post_notification "CamlCreateThreadNotification"

let test_sqlite () =
	let db = Sqlite3.db_open ~memory:true ""
	and cb row =
		Logs.debug (fun m -> m "Sqlite3 row fetched: %s" row.(0))
	in
	Logs.debug (fun m -> m "Sqlite3 ver: %s\n" @@ Sqlite3.sqlite_version_info ());
	Sqlite3.exec_not_null_no_headers db ~cb {|
		create table if not exists test (x text);
		insert into test (x) values ("Hola"), ("Mundo");
		select x from test;
	|} |> ignore

let application_did_finish_launching () =
	Logs.info (fun m -> m "application_did_finish_launching called");
	Cocoa.add_notification_observer
		"CamlSomeNotification"
		(fun msg -> Logs.debug
			(fun m -> m "Received CamlSomeNotification with arg: (%s)" msg));

	test_sqlite ();
	let db = Storage.init "app_db.sqlite" in
	Storage.test db;

	sexp_of_t {foo = 42; bar = 3.14}
	|> Sexp.to_string
	|> (fun s -> Logs.debug (fun m -> m "Sexp: %s" s));

	Thread.self ()
	|> Thread.id
	|> (fun s -> Logs.debug (fun m -> m "Main thread id: %d" s))

let register_callbacks () =
	Callback.register "fib" fib;
	Callback.register "format_result" format_result;
	Callback.register "test_threads" test_threads;
	Callback.register
		"application_did_finish_launching"
		application_did_finish_launching

let () =
	register_callbacks ();
	Logs.set_reporter (Logs.format_reporter ());
	Logs.set_level (Some Logs.Info);
	Logs_threaded.enable ()