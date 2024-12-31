//
//  EditViewController.h
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "../protocols/RefreshProtocol.h"
#import "../dataSource/TasksDataSource.h"
#import "../Models/Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditViewController : UIViewController <UIDocumentPickerDelegate>
@property Task* task;
@property id<RefreshProtocol> delegate;
@property TasksDataSource *tasksDataSource;
@end

NS_ASSUME_NONNULL_END
