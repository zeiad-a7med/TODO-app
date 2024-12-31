//
//  TasksDataSource.h
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import <Foundation/Foundation.h>
#import "../Models/Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TasksDataSource : NSObject
{
    NSUserDefaults *defults;
}
-(NSMutableArray*)getTasksWithKey:(NSString*)key AndKeyWord:(NSString*)keyWord;
-(BOOL)addTask:(Task*)task;
-(BOOL)deleteTask:(Task*)task;
-(BOOL)editTask:(Task *)task OldStatus:(NSString*)oldStatus;
@end

NS_ASSUME_NONNULL_END
