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

- (BOOL)isEqualToContentFetchRequest:(MUKContentFetchRequest *)request {
    BOOL const sameUserInfo = (!self.userInfo && !request.userInfo) || [self.userInfo isEqualToDictionary:request.userInfo];
    return sameUserInfo;
}

#pragma mark - Overrides

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[self class]]) {
        return [self isEqualToContentFetchRequest:object];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return 1838 ^ [self.userInfo hash];
}

@end
