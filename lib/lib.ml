let rec fib n =
	if n < 2 then 1
	else fib (n - 1) + fib (n - 2)

let format_result n =
	Printf.sprintf "Result is: %d\n" n

let test_threads n =
	Thread.self ()
	|> Thread.id
	|> Int.to_string
	|> Cocoa.post_notification "CamlCreateThreadNotification";
	Thread.join @@
		Thread.create
			(fun () ->
				let result = format_result (fib n) in
				Printf.eprintf "Message from thread: %s\n%!" result)
			()

let application_did_finish_launching () =
	Cocoa.add_notification_observer
		"UIDeviceOrientationDidChangeNotification"
		(fun () ->
			Printf.eprintf "Received UIDeviceOrientationDidChangeNotification\n%!")

let register_callbacks () =
	Callback.register "fib" fib;
	Callback.register "format_result" format_result;
	Callback.register "test_threads" test_threads;
	Callback.register
		"application_did_finish_launching"
		application_did_finish_launching

let () = register_callbacks ()