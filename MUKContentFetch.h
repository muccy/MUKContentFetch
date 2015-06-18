//
//  MUKContentFetch.h
//  
//
//  Created by Marco on 18/06/15.
//
//

#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchRequest.h>
#import <MUKContentFetch/MUKContentFetchResponse.h>

typedef NS_ENUM(NSInteger, MUKContentFetchRetrieveResultType) {
    MUKContentFetchRetrieveResultTypeFailed     = 0,
    MUKContentFetchRetrieveResultTypeSuccess    = 1,
    MUKContentFetchRetrieveResultTypeCancelled  = 2
};

@interface MUKContentFetch : NSObject
@property (nonatomic, readonly) MUKContentFetchRequest *request;
@property (nonatomic, readonly) MUKContentFetchResponse *response;

- (instancetype)initWithRequest:(MUKContentFetchRequest *)request;

- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse *response))completionHandler;
- (void)cancel;
@end

@interface MUKContentFetch (MethodsToOverride)
- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchRetrieveResultType resultType, id retrievedObject, NSError *error))completionHandler;
- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(id, NSError *))completionHandler;
@end
