//
//  InProgressViewController.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "InProgressViewController.h"
#import "EditViewController.h"
@interface InProgressViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isSorted;
@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];

    _heightArr = [NSMutableArray new];
    _mediumArr = [NSMutableArray new];
    _lowArr = [NSMutableArray new];
    _tasksDataSource = [TasksDataSource new];
}

- (void)viewWillAppear:(BOOL)animated {
    _isSorted = NO;
    [self getData];
    self.tabBarController.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(sort)];

    self.tabBarController.navigationItem.searchController = nil;
}

- (void)getData {
    _arr = [_tasksDataSource getTasksWithKey:INPROGRESS AndKeyWord:@""];
    if (_isSorted) {
        [self sortPeriority];
    }
    [self.tableView reloadData];
}
- (void)sortPeriority {
    NSSortDescriptor *sortDescriptor =
        [NSSortDescriptor sortDescriptorWithKey:@"periority" ascending:NO];
    [_arr sortUsingDescriptors:@[ sortDescriptor ]];
    
    
    
    [_heightArr removeAllObjects];
    [_mediumArr removeAllObjects];
    [_lowArr removeAllObjects];
    for (int i = 0; i < _arr.count; i++) {
        if ([_arr[i] periority] == HEIGHT_PERIORITY) {
            [_heightArr addObject:_arr[i]];
        }
        if ([_arr[i] periority] == MEDIUM_PERIORITY) {
            [_mediumArr addObject:_arr[i]];
        }
        if ([_arr[i] periority] == LOW_PERIORITY) {
            [_lowArr addObject:_arr[i]];
        }
    }
}
- (void)sort {
    _isSorted = (!_isSorted) ? YES : NO;
    self.tabBarController.navigationItem.rightBarButtonItem.title =
        (!_isSorted) ? @"Sort" : @"UnSort";
    [self getData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_isSorted) ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if (_isSorted) {
        switch (section) {
        case 0:
            return _heightArr.count;
            break;
        case 1:
            return _mediumArr.count;
            break;
        case 2:
            return _lowArr.count;
            break;
        default:
            return 0;
            break;
        }
    } else {
        return _arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoCell *cell = [[TodoCell alloc]
             initCellWithTask:(_isSorted) ? (indexPath.section == 0)
                                                ? _heightArr[indexPath.row]
                                            : (indexPath.section == 1)
                                                ? _mediumArr[indexPath.row]
                                                : _lowArr[indexPath.row]
                                          : self.arr[indexPath.row]
        cellForRowAtIndexPath:indexPath
                    tableView:tableView
               cellIdentifier:@"inProgressCell"];
    return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditViewController *avc =
        [self.storyboard instantiateViewControllerWithIdentifier:@"editTask"];
    avc.delegate = self;

    if (_isSorted) {
        switch (indexPath.section) {
        case 0:
            avc.task = _heightArr[indexPath.row];
            break;
        case 1:
            avc.task = _mediumArr[indexPath.row];
            break;
        case 2:
            avc.task = _lowArr[indexPath.row];
            break;
        default:

            break;
        }
    } else {
        avc.task = _arr[indexPath.row];
    }
    [self.navigationController pushViewController:avc animated:YES];
}
- (void)refreshTable {
    [self getData];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@""
                         message:@"are you sure you want to delete this Task"
                  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *delete = [UIAlertAction
        actionWithTitle:@"delete"
                  style:UIAlertActionStyleDestructive
                handler:^(UIAlertAction *_Nonnull action) {
                  [self.tasksDataSource
                      deleteTask:(_isSorted) ? (indexPath.section == 0)
                                                   ? _heightArr[indexPath.row]
                                               : (indexPath.section == 1)
                                                   ? _mediumArr[indexPath.row]
                                                   : _lowArr[indexPath.row]
                                             : self.arr[indexPath.row]];
                  [self.arr removeObjectAtIndex:indexPath.row];
                  [self refreshTable];
                }];
    UIAlertAction *cancel =
        [UIAlertAction actionWithTitle:@"cancel"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
    if (_isSorted) {
        switch (section) {
        case 0:
            return (_heightArr.count > 0) ? @"height" : nil;
            break;
        case 1:
            return (_mediumArr.count > 0) ? @"medium" : nil;
            break;
        case 2:
            return (_lowArr.count > 0) ? @"low" : nil;
            break;
        default:
            return nil;
            break;
        }
    } else {
        return @"";
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
    leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *action = [UIContextualAction
        contextualActionWithStyle:UIContextualActionStyleNormal
                            title:@"Done"
                          handler:^(UIContextualAction *action,
                                    UIView *sourceView,
                                    void (^completionHandler)(BOOL)) {
                            Task *updatedTask =
                                (_isSorted) ? (indexPath.section == 0)
                                                  ? _heightArr[indexPath.row]
                                              : (indexPath.section == 1)
                                                  ? _mediumArr[indexPath.row]
                                                  : _lowArr[indexPath.row]
                                            : self.arr[indexPath.row];

                            updatedTask.status = DONE_STATUS;
                            [_tasksDataSource editTask:updatedTask
                                             OldStatus:INPROGRESS];
                            [self refreshTable];
                            completionHandler(YES);
                          }];
    action.backgroundColor = [UIColor systemGreenColor];
    UISwipeActionsConfiguration *configuration;

    configuration =
        [UISwipeActionsConfiguration configurationWithActions:@[ action ]];

    return configuration;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
