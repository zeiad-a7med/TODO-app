//
//  TodoViewController.h
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

@interface TodoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,RefreshProtocol>
@property NSMutableArray *arr;
@property NSMutableArray *heightArr;
@property NSMutableArray *mediumArr;
@property NSMutableArray *lowArr;
@property NSMutableDictionary *TodoList;
@property TasksDataSource *tasksDataSource;
@end

NS_ASSUME_NONNULL_END
