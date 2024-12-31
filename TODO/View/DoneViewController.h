//
//  DoneViewController.h
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "../Customs/TodoCell.h"
#import "../dataSource/TasksDataSource.h"
#import "../constants/Constants.h"
#import "../protocols/RefreshProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RefreshProtocol>
@property NSMutableArray *arr;
@property NSMutableDictionary *TodoList;
@property NSMutableArray *heightArr;
@property NSMutableArray *mediumArr;
@property NSMutableArray *lowArr;
@property TasksDataSource *tasksDataSource;

@end

NS_ASSUME_NONNULL_END
