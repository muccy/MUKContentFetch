#import "MUKContentFetch.h"

@interface MUKContentFetch ()
@property (nonatomic, readwrite) MUKContentFetchResponse *response;
@property (nonatomic, readwrite, getter=isStarted) BOOL started;
@property (nonatomic, readwrite, getter=isCancelled) BOOL cancelled;
@property (nonatomic, copy) void (^completionHandler)(MUKContentFetchResponse *);
@end

@implementation MUKContentFetch

- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse<id> * _Nonnull))completionHandler
{
    // Fetch can be started once
    if (self.isStarted) {
        return;
    }
    self.started = YES;
    
    // Hold completion handler (mainly for cancellation)
    self.completionHandler = completionHandler;
    
    // I want to keep self in memory
    [self retrieveResourceWithCompletionHandler:^(MUKContentFetchResultType resultType, id retrievedObject, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (resultType) {
                case MUKContentFetchResultTypeSuccess: {
                    [self transformRetrievedObject:retrievedObject withCompletionHandler:^(MUKContentFetchResultType resultType, id transformedObject, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MUKContentFetchResponse *const response = [[MUKContentFetchResponse alloc] initWithResultType:resultType object:transformedObject error:error];
                            [self setResponseAndCallCompletionHandlerIfNeeded:response];
                        }); // dispatch_async
                    }]; // transformRetrievedObject
                    
                    break;
                }
                    
                case MUKContentFetchResultTypeFailed:
                case MUKContentFetchResultTypeCancelled:
                {
                    // Already on main queue
                    MUKContentFetchResponse *const response = [[MUKContentFetchResponse alloc] initWithResultType:resultType object:nil error:error];
                    [self setResponseAndCallCompletionHandlerIfNeeded:response];
                    break;
                }
            
                default:
                    self.completionHandler = nil;
                    break;
            }
        }); // dispatch_async
    }]; // retrieveResourceWithCompletionHandler
}

- (void)startWithCompletionTarget:(__weak id)target action:(SEL)action {
    [self startWithCompletionHandler:^(MUKContentFetchResponse * _Nonnull response) {
        __strong __typeof__(target) strongTarget = target;
        
        // Prevent leaks warning by using invocation
        // http://stackoverflow.com/a/28276187/224629
        NSMethodSignature *const signature = [strongTarget methodSignatureForSelector:action];
        
        if (signature) {
            NSInvocation *const invocation = [NSInvocation
                                           invocationWithMethodSignature:signature];
            invocation.target = strongTarget;
            invocation.selector = action;
            
            if (signature.numberOfArguments > 2) {
                [invocation setArgument:&response atIndex:2];
            }
            
            [invocation invoke];
        }
    }];
}

- (void)cancel {
    if ([self canSetResponse]) {
        self.cancelled = YES;
        MUKContentFetchResponse *const response = [[MUKContentFetchResponse alloc] initWithResultType:MUKContentFetchResultTypeCancelled object:nil error:nil];
        [self setResponseAndCallCompletionHandler:response];
    }
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -retrieveResourceWithCompletionHandler:");
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -transformRetrievedObject:withCompletionHandler:");
}

#pragma mark - Accessors

- (BOOL)isRunning {
    return self.isStarted && !self.response;
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingRunning {
    return [NSSet setWithObjects:@"started", NSStringFromSelector(@selector(response)), nil];
}

#pragma mark - Private

- (BOOL)canSetResponse {
    return self.isRunning;
}

- (void)setResponseAndCallCompletionHandler:(MUKContentFetchResponse *)response {
    self.response = response;
    
    if (self.completionHandler) {
        self.completionHandler(self.response);
        self.completionHandler = nil;
    }
}

- (void)setResponseAndCallCompletionHandlerIfNeeded:(MUKContentFetchResponse *)response
{
    if ([self canSetResponse]) {
        [self setResponseAndCallCompletionHandler:response];
    }
}

@end
