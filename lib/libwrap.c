#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>

#include "libwrap.h"

void
init_lib (char** argv)
{
	caml_startup(argv);
}

int
fib (int n)
{
	static const value * closure = NULL;
	if (closure == NULL) closure = caml_named_value("fib");
	return Int_val(caml_callback(*closure, Val_int(n)));
}

char *
format_result (int n)
{
	static const value * closure = NULL;
	if (closure == NULL) closure = caml_named_value("format_result");
	/* copy the C string to the C heap so that it remains valid after GC */
	return strdup(String_val(caml_callback(*closure, Val_int(n))));
}
