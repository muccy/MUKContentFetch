#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchRequest.h>
#import <MUKContentFetch/MUKContentFetchResponse.h>

/**
 Result type for an intermediate step of fetch
 */
typedef NS_ENUM(NSInteger, MUKContentFetchStepResultType) {
    /**
     Step failed
     */
    MUKContentFetchStepResultTypeFailed     = 0,
    /**
     Step success
     */
    MUKContentFetchStepResultTypeSuccess    = 1,
    /**
     Step cancelled
     */
    MUKContentFetchStepResultTypeCancelled  = 2
};

/**
 The fetch of a request which leads to a response
 */
@interface MUKContentFetch : NSObject
/**
 Request to satisfy
 */
@property (nonatomic, readonly) MUKContentFetchRequest *request;
/**
 Produced response
 */
@property (nonatomic, readonly) MUKContentFetchResponse *response;
/**
 YES when -startWithCompletionHandler: has been called
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;
/**
 Designated initializer
 */
- (instancetype)initWithRequest:(MUKContentFetchRequest *)request;
/**
 Start fetch
 @param completionHandler A block called on main queue when fetch finished
 */
- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse *response))completionHandler;
/*
 Cancel started fetch
 @discussion You can override this method to cancel started operations, if any, but
 remember to call super implementation. 
 If you call this method completionHandler provided to -startWithCompletionHandler:
 is properly called and response is set.
 */
- (void)cancel;
@end

@interface MUKContentFetch (MethodsToOverride)
/**
 Retrieve requested resource.
 @discussion You have to override this method. You can retrieve your resource how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to retrieve the 
 resource. You can call this block from any queue.
 */
- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchStepResultType resultType, id retrievedObject, NSError *error))completionHandler;
/**
 Transform retrieved resource into content object.
 @discussion You have to override this method. You can transform your object how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to transform the
 resource. You can call this block from any queue.
 */
- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchStepResultType resultType, id transformedObject, NSError *error))completionHandler;
@end
