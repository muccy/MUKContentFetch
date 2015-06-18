//
//  MUKContentFetchRequest.m
//  
//
//  Created by Marco on 18/06/15.
//
//

#import "MUKContentFetchRequest.h"

NSString *const MUKContentFetchRequestIntentUserInfoKey     = @"MUKContentFetchRequestIntentUserInfoKey";
NSString *const MUKContentFetchRequestStartIndexUserInfoKey = @"MUKContentFetchRequestStartIndexUserInfoKey";
NSString *const MUKContentFetchRequestItemCountUserInfoKey  = @"MUKContentFetchRequestItemCountUserInfoKey";

NSString *const MUKContentFetchRequestIntentOverwrite   = @"MUKContentFetchRequestIntentOverwrite";
NSString *const MUKContentFetchRequestIntentAppend      = @"MUKContentFetchRequestIntentAppend";
NSString *const MUKContentFetchRequestIntentPrepend     = @"MUKContentFetchRequestIntentPrepend";

@implementation MUKContentFetchRequest

- (instancetype)initWithUserInfo:(NSDictionary *)userInfo {
    self = [super init];
    if (self) {
        _userInfo = [userInfo copy];
    }
    
    return self;
}

@end
