external add_notification_observer : string -> (string -> unit) -> unit =
	"caml_add_notification_observer"

external post_notification : string -> string -> unit =
	"caml_post_notification"

external get_documents_directory : unit -> string =
	"caml_get_documents_directory"