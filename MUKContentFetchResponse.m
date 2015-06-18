#import "MUKContentFetchResponse.h"

@implementation MUKContentFetchResponse

- (instancetype)initWithType:(MUKContentFetchResponseType)type object:(id)object error:(NSError *)error
{
    self = [super init];
    if (self) {
        _type = type;
        _object = object;
        _error = error;
    }
    
    return self;
}

- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response {
    BOOL const sameType = self.type == response.type;
    BOOL const sameObject = [self.object isEqual:response.object];
    BOOL const sameError = (!self.error && !response.error) || [self.error isEqual:response.error];
    return sameType && sameObject && sameError;
}

#pragma mark - Overrides

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[self class]]) {
        return [self isEqualToContentFetchResponse:object];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return 58493 ^ self.type ^ [self.object hash] ^ [self.error hash];
}

@end
