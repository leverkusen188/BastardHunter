1. You need to #import "BustersCatcher.h"
2. Use [[BustersCatcher sharedInstance] isDealloc:target]  to judge if the target is dealloced.
3. Some defined macro can help you do some hard work.
Like  Safe_Release(obj),  it can release the object safely and set it to nil.
Use Weak_Obj and Weak_GetObj by pair, in no-arc mode, it can do the  "__weak"  work.
NSObject    *p = [[[NSObject alloc] init] autorelease];
Weak_Obj(p);
[[NSOperationQueue mainQueue] addOperationWithBlock:^{
id weakP = Weak_GetObj(p);
NSLog(@"Obj===%@",weakP);   //must be nil.
}];