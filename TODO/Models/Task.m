//
//  Task.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "Task.h"
#import "../constants/Constants.h"
@implementation Task
- (void)encodeWithCoder:(nonnull NSCoder *)encoder {
    [encoder encodeInteger:_tid forKey:@"tid"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_details forKey:@"details"];
    [encoder encodeInteger:_periority forKey:@"periority"];
    [encoder encodeInteger:_status forKey:@"status"];
    [encoder encodeObject:_endDate forKey:@"endDate"];
    [encoder encodeObject:_document forKey:@"document"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self = [super init];
    if (self) {
        _tid = [decoder decodeIntegerForKey:@"tid"];
        _title = [decoder decodeObjectForKey:@"title"];
        _details = [decoder decodeObjectForKey:@"details"];
        _periority = [decoder decodeIntegerForKey:@"periority"];
        _status = [decoder decodeIntegerForKey:@"status"];
        _endDate = [decoder decodeObjectForKey:@"endDate"];
        _document = [decoder decodeObjectForKey:@"document"];
    }
    return self;
}
-(BOOL)validFields{
    if (self.title.length != 0 && self.details.length != 0) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)supportsSecureCoding {
    return YES;
}
-(NSString*)getStatusKey{
    NSString * type ;
    if (_status == TODO_STATUS) {
        return TODO;
    }else if (_status == INPROGRESS_STATUS){
        return INPROGRESS;
    }else if (_status == DONE_STATUS){
        return DONE;
    }else{
        return TODO;
    }
}

+(NSInteger)getStatusFromKey:(NSString *)key{
    if (key == TODO) {
        return TODO_STATUS;
    }else if (key == INPROGRESS){
        return INPROGRESS_STATUS;
    }else if (key == DONE){
        return DONE_STATUS;
    }else{
        return TODO_STATUS;
    }
}
@end
