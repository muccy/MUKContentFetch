#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchResultType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Result of a fetch
 */
@interface MUKContentFetchResponse<__covariant ObjectType> : NSObject
/**
 Result type
 */
@property (nonatomic, readonly) MUKContentFetchResultType resultType;
/**
 Fetched object
 */
@property (nonatomic, readonly, nullable) ObjectType object;
/**
 Fetch error
 */
@property (nonatomic, readonly, nullable) NSError *error;
/**
 Designated initializer
 */
- (instancetype)initWithResultType:(MUKContentFetchResultType)resultType object:(nullable ObjectType)object error:(nullable NSError *)error NS_DESIGNATED_INITIALIZER;
/**
 @returns YES when response is equal to self
 */
- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response;
@end

NS_ASSUME_NONNULL_END
