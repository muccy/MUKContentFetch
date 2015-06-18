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
@property (nonatomic, readonly) id object;
@property (nonatomic, readonly) NSError *error;
- (instancetype)initWithType:(MUKContentFetchResponseType)type object:(id)object error:(NSError *)error;
- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response;
@end
