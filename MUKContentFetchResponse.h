//
//  MUKContentFetchResponse.h
//  
//
//  Created by Marco on 18/06/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MUKContentFetchResponseType) {
    MUKContentFetchResponseTypeFailed       = 0,
    MUKContentFetchResponseTypeSuccess      = 1,
    MUKContentFetchResponseTypeCancelled    = 2
};

@interface MUKContentFetchResponse : NSObject
@property (nonatomic, readonly) MUKContentFetchResponseType type;
@property (nonatomic, readonly) id fetchedObject;
@property (nonatomic, readonly) NSError *error;
- (instancetype)initWithType:(MUKContentFetchResponseType)type fetchedObject:(id)fetchedObject error:(NSError *)error;
@end
