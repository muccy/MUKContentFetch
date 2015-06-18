#import "MUKContentFetch.h"

@interface MUKContentFetch ()
@property (nonatomic, readwrite) MUKContentFetchResponse *response;
@property (nonatomic, readwrite, getter=isStarted) BOOL started;
@property (nonatomic, copy) void (^completionHandler)(MUKContentFetchResponse *);
@end

@implementation MUKContentFetch

- (instancetype)initWithRequest:(MUKContentFetchRequest *)request {
    self = [super init];
    if (self) {
        _request = request;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithRequest:[[MUKContentFetchRequest alloc] initWithUserInfo:nil]];
}

- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse *))completionHandler
{
    // Fetch can be started once
    if (self.isStarted) {
        return;
    }
    self.started = YES;
    
    // Hold completion handler (mainly for cancellation)
    self.completionHandler = completionHandler;
    
    // I want to keep self in memory
    [self retrieveResourceWithCompletionHandler:^(MUKContentFetchStepResultType resultType, id retrievedObject, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (resultType) {
                case MUKContentFetchStepResultTypeSuccess: {
                    [self transformRetrievedObject:retrievedObject withCompletionHandler:^(MUKContentFetchStepResultType resultType, id transformedObject, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:ResponseTypeFromStepResultType(resultType) object:transformedObject error:error]];
                        }); // dispatch_async
                    }]; // transformRetrievedObject
                    
                    break;
                }
                    
                case MUKContentFetchStepResultTypeFailed:
                case MUKContentFetchStepResultTypeCancelled:
                    [self setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:ResponseTypeFromStepResultType(resultType) object:nil error:error]];
                    break;
            
                default:
                    self.completionHandler = nil;
                    break;
            }
        }); // dispatch_async
    }]; // retrieveResourceWithCompletionHandler
}

- (void)cancel {
    [self setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:MUKContentFetchResponseTypeCancelled object:nil error:nil]];
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchStepResultType, id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -retrieveResourceWithCompletionHandler:");
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchStepResultType, id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -transformRetrievedObject:withCompletionHandler:");
}

#pragma mark - Private

- (void)setResponseAndCallCompletionHandlerIfNeeded:(MUKContentFetchResponse *)response
{
    if (!self.response && self.isStarted) {
        self.response = response;
        
        if (self.completionHandler) {
            self.completionHandler(self.response);
            self.completionHandler = nil;
        }
    }
}

static MUKContentFetchResponseType ResponseTypeFromStepResultType(MUKContentFetchStepResultType stepResultType)
{
    MUKContentFetchResponseType responseType;
    
    switch (stepResultType) {
        case MUKContentFetchStepResultTypeCancelled:
            responseType = MUKContentFetchResponseTypeCancelled;
            break;
            
        case MUKContentFetchStepResultTypeFailed:
            responseType = MUKContentFetchResponseTypeFailed;
            break;
            
        case MUKContentFetchStepResultTypeSuccess:
            responseType = MUKContentFetchResponseTypeSuccess;
    }
    
    return responseType;
}

@end
