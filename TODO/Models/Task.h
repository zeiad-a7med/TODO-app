//
//  Task.h
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding,NSSecureCoding>
@property NSInteger tid;
@property NSString * title;
@property NSString * details;
@property NSInteger periority;
@property NSInteger status;
@property NSDate * endDate;
@property NSURL * document;
-(BOOL)validFields;
-(NSString*)getStatusKey;
+(NSInteger)getStatusFromKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
