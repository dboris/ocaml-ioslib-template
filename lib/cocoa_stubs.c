#import <Foundation/Foundation.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>


CAMLprim void
caml_add_notification_observer (value val_note_name, value val_observer_f)
{
	CAMLparam2(val_note_name, val_observer_f);

	NSString * notification_name =
		[NSString stringWithUTF8String:String_val(val_note_name)];

	[[NSNotificationCenter defaultCenter]
		addObserverForName:notification_name
		object:nil
		queue:[NSOperationQueue mainQueue]
		usingBlock:^(NSNotification * _note) {
			caml_callback(val_observer_f, Val_unit);
		}];
}

CAMLprim void
caml_post_notification (value val_note_name, value val_serialized_arg)
{
	CAMLparam2(val_note_name, val_serialized_arg);

	NSString * notification_name =
		[NSString stringWithUTF8String:String_val(val_note_name)];

	NSDictionary * user_info =
		@{
			@"arg": [NSString stringWithUTF8String:String_val(val_serialized_arg)]
		};

	[[NSNotificationCenter defaultCenter]
		postNotificationName:notification_name
		object:nil
		userInfo:user_info];
}
