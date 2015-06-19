//
//  MUKContentFetchTests.m
//  MUKContentFetchTests
//
//  Created by Marco on 18/06/15.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <MUKContentFetch/MUKContentFetch.h>

@interface TimeoutFetch : MUKContentFetch
@property (nonatomic, readonly) NSTimeInterval retrieveTimeout, transformTimeout;
- (instancetype)initWithRetrieveTimeout:(NSTimeInterval)retrieveTimeout transformTimeout:(NSTimeInterval)transformTimeout;
@end

@implementation TimeoutFetch

- (instancetype)initWithRetrieveTimeout:(NSTimeInterval)retrieveTimeout transformTimeout:(NSTimeInterval)transformTimeout
{
    self = [super init];
    if (self) {
        _retrieveTimeout = retrieveTimeout;
        _transformTimeout = transformTimeout;
    }
    
    return self;
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.retrieveTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionHandler(MUKContentFetchResultTypeSuccess, nil, nil);
    });
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.transformTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionHandler(MUKContentFetchResultTypeSuccess, nil, nil);
    });
}

@end

#pragma mark -

@interface SyncFetch : MUKContentFetch
@property (nonatomic, readonly) MUKContentFetchResultType retrieveResultType, transformResultType;
@property (nonatomic, readonly) id retrievedObject, transformedObject;
@property (nonatomic, readonly) NSError *retrieveError, *transformError;
@property (nonatomic, readonly) BOOL retrieveAttempted, transformAttempted;

- (instancetype)initWithRetrieveResultType:(MUKContentFetchResultType)retrieveResultType object:(id)retrievedObject error:(NSError *)retrieveError transformResultType:(MUKContentFetchResultType)transformResultType object:(id)transformedObject error:(NSError *)transformError;
@end

@implementation SyncFetch

- (instancetype)initWithRetrieveResultType:(MUKContentFetchResultType)retrieveResultType object:(id)retrievedObject error:(NSError *)retrieveError transformResultType:(MUKContentFetchResultType)transformResultType object:(id)transformedObject error:(NSError *)transformError
{
    self = [super init];
    if (self) {
        _retrieveResultType = retrieveResultType;
        _retrievedObject = retrievedObject;
        _retrieveError = retrieveError;
        
        _transformResultType = transformResultType;
        _transformedObject = transformedObject;
        _transformError = transformError;
    }
    
    return self;
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    _retrieveAttempted = YES;
    completionHandler(self.retrieveResultType, self.retrievedObject, self.retrieveError);
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType, id, NSError *))completionHandler
{
    _transformAttempted = YES;
    completionHandler(self.transformResultType, self.transformedObject, self.transformError);
}

@end

#pragma mark -

@interface MUKContentFetchTests : XCTestCase
@end

@implementation MUKContentFetchTests

- (void)testInitialization {
    MUKContentFetchRequest *request = [[MUKContentFetchRequest alloc] initWithUserInfo:@{ @"key" : @"value" }];
    MUKContentFetch *fetch = [[MUKContentFetch alloc] initWithRequest:request];
    XCTAssertEqualObjects(fetch.request, request);
    XCTAssertNil(fetch.response);
    XCTAssertFalse(fetch.isStarted);
    XCTAssertFalse(fetch.isCancelled);

    request = [[MUKContentFetchRequest alloc] initWithUserInfo:nil];
    fetch = [[MUKContentFetch alloc] init];
    XCTAssertEqualObjects(fetch.request, request);
    XCTAssertNil(fetch.response);
    XCTAssertFalse(fetch.isStarted);
    XCTAssertFalse(fetch.isCancelled);
}

- (void)testEarlyCancellation {
    MUKContentFetch *const fetch = [[MUKContentFetch alloc] init];
    XCTAssertFalse(fetch.isStarted);
    XCTAssertNoThrow([fetch cancel]);
    XCTAssertNil(fetch.response);
    XCTAssertFalse(fetch.isCancelled);
}

- (void)testStart {
    TimeoutFetch *const fetch = [[TimeoutFetch alloc] initWithRetrieveTimeout:0.2 transformTimeout:0.2];

    XCTestExpectation *completionHandlerExpection = [self expectationWithDescription:@"Completion handler called"];
    
    __weak typeof(fetch) weakFetch = fetch;
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
        __strong __typeof(weakFetch) strongFetch = weakFetch;
        XCTAssert(response != nil);
        XCTAssertEqualObjects(strongFetch.response, response);
        [completionHandlerExpection fulfill];
    }];
    
    XCTAssertTrue(fetch.isStarted);
    XCTAssertFalse(fetch.isCancelled);
    
    [self waitForExpectationsWithTimeout:(fetch.retrieveTimeout + fetch.transformTimeout) * 2.0 handler:nil];
}

- (void)testCancellation {
    TimeoutFetch *const fetch = [[TimeoutFetch alloc] initWithRetrieveTimeout:0.2 transformTimeout:0.2];
    
    XCTestExpectation *completionHandlerExpection = [self expectationWithDescription:@"Completion handler called"];
    
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
        XCTAssertEqual(response.resultType, MUKContentFetchResultTypeCancelled);
        [completionHandlerExpection fulfill];
    }];
    
    XCTAssertTrue(fetch.isStarted);
    XCTAssertFalse(fetch.isCancelled);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(fetch.retrieveTimeout * 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        [fetch cancel];
        XCTAssertTrue(fetch.isCancelled);
    });
    
    [self waitForExpectationsWithTimeout:(fetch.retrieveTimeout + fetch.transformTimeout) * 2.0 handler:nil];
}

- (void)testRetrieveFailure {
    NSError *const error = [NSError errorWithDomain:@"TestDomain" code:11 userInfo:nil];
    SyncFetch *const fetch = [[SyncFetch alloc] initWithRetrieveResultType:MUKContentFetchResultTypeFailed object:nil error:error transformResultType:0 object:nil error:nil];
    
    XCTestExpectation *completionHandlerExpection = [self expectationWithDescription:@"Completion handler called"];
    
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
        XCTAssertEqual(response.resultType, MUKContentFetchResultTypeFailed);
        XCTAssertEqualObjects(response.error, error);
        
        XCTAssert(fetch.retrieveAttempted);
        XCTAssertFalse(fetch.transformAttempted);
        
        [completionHandlerExpection fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testTransformFailure {
    NSError *const error = [NSError errorWithDomain:@"TestDomain" code:11 userInfo:nil];
    SyncFetch *const fetch = [[SyncFetch alloc] initWithRetrieveResultType:MUKContentFetchResultTypeSuccess object:nil error:nil transformResultType:MUKContentFetchResultTypeFailed object:nil error:error];
    
    XCTestExpectation *completionHandlerExpection = [self expectationWithDescription:@"Completion handler called"];
    
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
        XCTAssertEqual(response.resultType, MUKContentFetchResultTypeFailed);
        XCTAssertEqualObjects(response.error, error);
        
        XCTAssert(fetch.retrieveAttempted);
        XCTAssert(fetch.transformAttempted);
        
        [completionHandlerExpection fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testTransformSuccess {
    id const object = @"!";
    SyncFetch *const fetch = [[SyncFetch alloc] initWithRetrieveResultType:MUKContentFetchResultTypeSuccess object:object error:nil transformResultType:MUKContentFetchResultTypeSuccess object:object error:nil];
    
    XCTestExpectation *completionHandlerExpection = [self expectationWithDescription:@"Completion handler called"];
    
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
        XCTAssertEqual(response.resultType, MUKContentFetchResultTypeSuccess);
        XCTAssertEqualObjects(response.object, object);
        
        XCTAssert(fetch.retrieveAttempted);
        XCTAssert(fetch.transformAttempted);
        
        [completionHandlerExpection fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
