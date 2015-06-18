//
//  MUKContentFetchResponse.m
//  
//
//  Created by Marco on 18/06/15.
//
//

#import "MUKContentFetchResponse.h"

@implementation MUKContentFetchResponse

- (instancetype)initWithType:(MUKContentFetchResponseType)type fetchedObject:(id)fetchedObject error:(NSError *)error
{
    self = [super init];
    if (self) {
        _type = type;
        _fetchedObject = fetchedObject;
        _error = error;
    }
    
    return self;
}

@end
