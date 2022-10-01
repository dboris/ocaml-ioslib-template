(* Persistent sqlite store *)

let file_exists filename =
	try ignore (Unix.stat filename); true
	with Unix.Unix_error (Unix.ENOENT, _, _) -> false

let create_schema db =
	Sqlite3.exec db {sql|
		create table count (n int);
		insert into count (n) values (0);
	|sql} |> ignore

let init db_filename =
	let filename =
		Cocoa.get_documents_directory () ^ "/" ^ db_filename in
	let first_run = not (file_exists filename)
	and db = Sqlite3.db_open filename
	in
	if first_run then create_schema db;
	db

let test db =
	let cb row =
		Printf.eprintf "Sqlite3 count: n=%s\n%!" row.(0)
	in
	Sqlite3.exec_not_null_no_headers db ~cb {sql|
		select n from count;
	|sql} |> ignore;
	Sqlite3.exec db {sql|
		update count set n = n + 1;
	|sql} |> ignore
