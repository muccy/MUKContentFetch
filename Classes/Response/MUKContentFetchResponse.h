#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchResultType.h>

/**
 Result of a fetch
 */
@interface MUKContentFetchResponse : NSObject
/**
 Result type
 */
@property (nonatomic, readonly) MUKContentFetchResultType resultType;
/**
 Fetched object
 */
@property (nonatomic, readonly) id object;
/**
 Fetch error
 */
@property (nonatomic, readonly) NSError *error;
/**
 Designated initializer
 */
- (instancetype)initWithResultType:(MUKContentFetchResultType)resultType object:(id)object error:(NSError *)error;
/**
 @returns YES when response is equal to self
 */
- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response;
@end
