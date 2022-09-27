#import <Foundation/Foundation.h>

#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>


CAMLprim void
caml_add_notification_observer (value notification_name, value callback_f)
{
	CAMLparam2(notification_name, callback_f);
	NSString * name = [NSString
		stringWithUTF8String:String_val(notification_name)];
	[[NSNotificationCenter defaultCenter]
		addObserverForName:name
		object:nil
		queue:[NSOperationQueue mainQueue]
		usingBlock:^(NSNotification * _note) {
			caml_callback(callback_f, Val_unit);
		}];
}