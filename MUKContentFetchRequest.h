//
//  MUKContentFetchRequest.h
//  
//
//  Created by Marco on 18/06/15.
//
//

#import <Foundation/Foundation.h>

// Common keys
extern NSString *const MUKContentFetchRequestIntentUserInfoKey;
extern NSString *const MUKContentFetchRequestStartIndexUserInfoKey;
extern NSString *const MUKContentFetchRequestItemCountUserInfoKey;

extern NSString *const MUKContentFetchRequestIntentOverwrite;
extern NSString *const MUKContentFetchRequestIntentAppend;
extern NSString *const MUKContentFetchRequestIntentPrepend;

@interface MUKContentFetchRequest : NSObject
@property (nonatomic, copy, readonly) NSDictionary *userInfo;
- (instancetype)initWithUserInfo:(NSDictionary *)userInfo;
@end
