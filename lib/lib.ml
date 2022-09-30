let rec fib n =
	if n < 2 then 1
	else fib (n - 1) + fib (n - 2)

let format_result n =
	Printf.sprintf "Result is: %d\n" n

let test_threads n =
	let t = Thread.create
		(fun () ->
			let result = format_result (fib n) in
			Printf.eprintf "Message from thread: %s\n%!" result)
		()
	in
	Thread.id t
	|> Int.to_string
	|> Cocoa.post_notification "CamlCreateThreadNotification"

let test_sqlite () =
	Sqlite3.sqlite_version_info ()
	|> Printf.eprintf "Sqlite3 ver: %s\n%!";
	let db = Sqlite3.db_open ~memory:true ""
	and cb row =
		Printf.eprintf "Sqlite3 row fetched: %s\n%!" row.(0)
	in
	Sqlite3.exec_not_null_no_headers db ~cb {|
		create table if not exists test (x text);
		insert into test (x) values ("Hola"), ("Mundo");
		select x from test;
	|}

let application_did_finish_launching () =
	Cocoa.add_notification_observer
		"CamlSomeNotification"
		(fun arg ->
			Printf.eprintf "Received CamlSomeNotification with arg: (%s)\n%!" arg);
	test_sqlite ()

let register_callbacks () =
	Callback.register "fib" fib;
	Callback.register "format_result" format_result;
	Callback.register "test_threads" test_threads;
	Callback.register
		"application_did_finish_launching"
		application_did_finish_launching

let () = register_callbacks ()