#import <Foundation/Foundation.h>

/**
 Common user info key to describe fetch intent
 */
extern NSString *const MUKContentFetchRequestIntentUserInfoKey;
/**
 Common user info key to indicate first requested item index
 */
extern NSString *const MUKContentFetchRequestStartIndexUserInfoKey;
/**
 Common user info key to indicate how many items are requested
 */
extern NSString *const MUKContentFetchRequestItemCountUserInfoKey;

/**
 Common value for MUKContentFetchRequestIntentUserInfoKey: it describes intent 
 to overwrite contents
 */
extern NSString *const MUKContentFetchRequestIntentOverwrite;
/**
 Common value for MUKContentFetchRequestIntentUserInfoKey: it describes intent
 to append new contents
 */
extern NSString *const MUKContentFetchRequestIntentAppend;
/**
 Common value for MUKContentFetchRequestIntentUserInfoKey: it describes intent
 to prepend new contents
 */
extern NSString *const MUKContentFetchRequestIntentPrepend;

/**
 Request to fetch contents
 */
@interface MUKContentFetchRequest : NSObject
/**
 Additional infos to describe what to fetch
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;
/**
 Designated initializer
 */
- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;
/**
 @returns YES when request is equal to self
 */
- (BOOL)isEqualToContentFetchRequest:(MUKContentFetchRequest *)request;
@end
