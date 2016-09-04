#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchResponse.h>
#import <MUKContentFetch/MUKContentFetchResultType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The fetch of a request which leads to a response
 */
@interface MUKContentFetch<__covariant ObjectType> : NSObject
/**
 Produced response
 */
@property (nonatomic, readonly, nullable) MUKContentFetchResponse<ObjectType> *response;
/**
 YES when -startWithCompletionHandler: has been called
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;
/**
 YES when -cancel has been called
 */
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;
/**
 YES when this fetch is started but not finished
 */
@property (nonatomic, readonly, getter=isRunning) BOOL running;
/**
 Start fetch
 @param completionHandler A block called on main queue when fetch finished
 */
- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse<ObjectType> *response))completionHandler;
/**
 Start fetch
 @param target The object which is invoked at completion. This object is not
 retained.
 @param action The selector invoked on target at completion.
 */
- (void)startWithCompletionTarget:(id __weak)target action:(SEL)action;
/*
 Cancel started fetch
 @discussion You can override this method to cancel started operations, if any, but
 remember to call super implementation. 
 If you call this method completionHandler provided to -startWithCompletionHandler:
 is properly called and response is set.
 */
- (void)cancel;

#pragma mark Methods to override

/**
 Retrieve requested resource.
 @discussion You have to override this method. You can retrieve your resource how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to retrieve the 
 resource. You can call this block from any queue.
 */
- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType resultType, id _Nullable retrievedObject, NSError * _Nullable error))completionHandler;
/**
 Transform retrieved resource into content object.
 @discussion You have to override this method. You can transform your object how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to transform the
 resource. You can call this block from any queue.
 */
- (void)transformRetrievedObject:(nullable id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType resultType, ObjectType _Nullable transformedObject, NSError *_Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
