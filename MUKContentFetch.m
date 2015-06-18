//
//  MUKContentFetch.m
//  
//
//  Created by Marco on 18/06/15.
//
//

#import "MUKContentFetch.h"

@interface MUKContentFetch ()
@property (nonatomic, readwrite) MUKContentFetchResponse *response;
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

- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse *))completionHandler
{
    __weak typeof(self) weakSelf = self;
    self.completionHandler = completionHandler;
    
    [self retrieveResourceWithCompletionHandler:^(MUKContentFetchRetrieveResultType resultType, id retrievedObject, NSError *error)
    {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (resultType) {
                case MUKContentFetchRetrieveResultTypeSuccess: {
                    [self transformRetrievedObject:retrievedObject withCompletionHandler:^(id transformedObject, NSError *error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:MUKContentFetchResponseTypeSuccess fetchedObject:transformedObject error:error]];
                        }); // dispatch_async
                    }]; // transformRetrievedObject
                    
                    break;
                }
                    
                case MUKContentFetchRetrieveResultTypeFailed: {
                    [strongSelf setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:MUKContentFetchResponseTypeFailed fetchedObject:nil error:error]];
                    break;
                }
                    
                case MUKContentFetchRetrieveResultTypeCancelled: {
                    [strongSelf setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:MUKContentFetchResponseTypeCancelled fetchedObject:nil error:error]];
                    break;
                }
                    
                default:
                    break;
            }
        }); // dispatch_async
    }]; // retrieveResourceWithCompletionHandler
}

- (void)cancel {
    [self setResponseAndCallCompletionHandlerIfNeeded:[[MUKContentFetchResponse alloc] initWithType:MUKContentFetchResponseTypeCancelled fetchedObject:nil error:nil]];
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchRetrieveResultType, id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -retrieveResourceWithCompletionHandler:");
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(id, NSError *))completionHandler
{
    NSAssert(NO, @"You must override -transformRetrievedObject:withCompletionHandler:");
}

#pragma mark - Private

- (void)setResponseAndCallCompletionHandlerIfNeeded:(MUKContentFetchResponse *)response
{
    if (!self.response) {
        self.response = response;
        
        if (self.completionHandler) {
            self.completionHandler(self.response);
            self.completionHandler = nil;
        }
    }
}

@end
