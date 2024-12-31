//
//  TasksDataSource.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "TasksDataSource.h"
#import "../constants/Constants.h"
#import <UserNotifications/UserNotifications.h>
@implementation TasksDataSource
- (instancetype)init {
    self = [super init];
    if (self) {
        defults = [NSUserDefaults standardUserDefaults];
        NSInteger tid = [defults integerForKey:TID];
        if (tid == 0) {
            tid = 0;
            [defults setInteger:tid forKey:TID];
        }
    }
    return self;
}

- (NSMutableArray *)getTasksWithKey:(NSString *)key
                         AndKeyWord:(NSString *)keyWord {
    NSData *savedData =
        [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSMutableArray *decodedArray =
        [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
    if (decodedArray == nil) {
        decodedArray = [NSMutableArray new];
    }

    NSArray *filteredArray;

    if (keyWord.length == 0) {
        filteredArray = [decodedArray copy];
    } else {
        NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@", keyWord];
        filteredArray = [decodedArray filteredArrayUsingPredicate:predicate];
    }

    return [[NSMutableArray alloc] initWithArray:filteredArray];
}

- (BOOL)addTask:(Task *)task {
    task.tid = [self getPrimaryKeyForEntry];
    NSMutableArray *customArray = [self getTasksWithKey:[task getStatusKey]
                                             AndKeyWord:@""];
    [customArray addObject:task];
    NSData *encodedArray =
        [NSKeyedArchiver archivedDataWithRootObject:customArray
                              requiringSecureCoding:NO
                                              error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:encodedArray
                                              forKey:[task getStatusKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self scheduleLocalNotificationWithTask:task];
    return YES;
}

- (BOOL)editTask:(Task *)task OldStatus:(NSString *)oldStatus {
    if ([task getStatusKey] != oldStatus) {
        Task *oldTask = [Task new];
        oldTask.tid = task.tid;
        oldTask.status = [Task getStatusFromKey:oldStatus];
        [self deleteTask:oldTask];
        [self addTask:task];
    } else {
        NSMutableArray *customArray = [self getTasksWithKey:[task getStatusKey]
                                                 AndKeyWord:@""];
        for (int i = 0; i < customArray.count; i++) {
            if ([customArray[i] tid] == task.tid) {
                customArray[i] = task;
                break;
            }
        }
        NSData *encodedArray =
            [NSKeyedArchiver archivedDataWithRootObject:customArray
                                  requiringSecureCoding:NO
                                                  error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:encodedArray
                                                  forKey:[task getStatusKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}

- (BOOL)deleteTask:(Task *)task {
    NSMutableArray *customArray = [self getTasksWithKey:[task getStatusKey]
                                             AndKeyWord:@""];
    for (int i = 0; i < customArray.count; i++) {
        if ([customArray[i] tid] == task.tid) {
            [customArray removeObjectAtIndex:i];
            break;
        }
    }
    NSData *encodedArray =
        [NSKeyedArchiver archivedDataWithRootObject:customArray
                              requiringSecureCoding:NO
                                              error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:encodedArray
                                              forKey:[task getStatusKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (NSInteger)getPrimaryKeyForEntry {
    NSInteger tid = [defults integerForKey:TID];
    tid++;
    [defults setInteger:tid forKey:TID];
    return tid;
}

- (void)scheduleLocalNotificationWithTask:(Task *)task {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents =
        [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |
                              NSCalendarUnitDay | NSCalendarUnitHour |
                              NSCalendarUnitMinute | NSCalendarUnitSecond)
                    fromDate:task.endDate];

    // Create the trigger with the extracted date components
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
        triggerWithDateMatchingComponents:dateComponents
                                  repeats:NO];

    // Create the content for the notification
    UNMutableNotificationContent *content =
        [[UNMutableNotificationContent alloc] init];
    content.title = @"Reminder";
    content.body = [NSString stringWithFormat:@"reminding you with %@",task.title];
    content.sound = [UNNotificationSound defaultSound];

    // Create a unique identifier for the notification
    NSString *identifier = @"MyNotification";

    // Create the notification request
    UNNotificationRequest *request =
        [UNNotificationRequest requestWithIdentifier:identifier
                                             content:content
                                             trigger:trigger];

    // Add the request to the notification center
    UNUserNotificationCenter *center =
        [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request
             withCompletionHandler:^(NSError *_Nullable error) {
               if (error) {
                   NSLog(@"Error adding notification: %@",
                         error.localizedDescription);
               } else {
                   NSLog(@"Notification scheduled for %@", task.endDate);
               }
             }];
}
@end
