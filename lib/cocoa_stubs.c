#import <Foundation/Foundation.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>


CAMLprim void
caml_add_notification_observer (value notification_name, value observer_f)
{
	CAMLparam2(notification_name, observer_f);

	NSString * name =
		[NSString stringWithUTF8String:String_val(notification_name)];

	[[NSNotificationCenter defaultCenter]
		addObserverForName:name
		object:nil
		queue:[NSOperationQueue mainQueue]
		usingBlock:^(NSNotification * _note) {
			caml_callback(observer_f, Val_unit);
		}];
}

CAMLprim void
caml_post_notification (value notification_name, value serialized_arg)
{
	CAMLparam2(notification_name, serialized_arg);

	NSString * name =
		[NSString stringWithUTF8String:String_val(notification_name)];

	NSDictionary * user_info =
		@{ @"arg": [NSString stringWithUTF8String:String_val(serialized_arg)] };

	[[NSNotificationCenter defaultCenter]
		postNotificationName:name
		object:nil
		userInfo:user_info];
}
