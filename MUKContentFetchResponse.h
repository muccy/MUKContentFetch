#import <Foundation/Foundation.h>

/**
 Response result type
 */
typedef NS_ENUM(NSInteger, MUKContentFetchResponseType) {
    /**
     Fetch failed
     */
    MUKContentFetchResponseTypeFailed       = 0,
    /**
     Fetch success
     */
    MUKContentFetchResponseTypeSuccess      = 1,
    /**
     Fetch cancelled
     */
    MUKContentFetchResponseTypeCancelled    = 2
};

/**
 Result of a fetch
 */
@interface MUKContentFetchResponse : NSObject
/**
 Result type
 */
@property (nonatomic, readonly) MUKContentFetchResponseType type;
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
- (instancetype)initWithType:(MUKContentFetchResponseType)type object:(id)object error:(NSError *)error;
/**
 @returns YES when response is equal to self
 */
- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response;
@end
