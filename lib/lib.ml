let rec fib n =
	if n < 2 then 1
	else fib (n - 1) + fib (n - 2)

let format_result n =
	Printf.sprintf "Result is: %d\n" n

let test_threads n =
	Thread.join @@
		Thread.create
			(fun () ->
				let result = format_result (fib n) in
				Printf.eprintf "Message from thread: %s\n%!" result)
			()

let () =
	Callback.register "fib" fib;
	Callback.register "format_result" format_result;
	Callback.register "test_threads" test_threads
