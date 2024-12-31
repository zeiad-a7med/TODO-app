//
//  TodoViewController.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "TodoViewController.h"
#import "AddViewController.h"
#import "EditViewController.h"
@interface TodoViewController ()
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *keyword;
@end

@implementation TodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:_tableView];
    _heightArr = [NSMutableArray new];
    _mediumArr = [NSMutableArray new];
    _lowArr = [NSMutableArray new];
    _keyword = @"";
    _tasksDataSource = [TasksDataSource new];
}
- (void)viewWillAppear:(BOOL)animated {
    [self getData];
    self.tabBarController.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"+"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(addTask)];
    UISearchController *searchController =
        [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
    self.tabBarController.navigationItem.searchController = searchController;
    self.tabBarController.navigationItem.hidesSearchBarWhenScrolling = NO;
}

- (void)getData {
    _arr = [_tasksDataSource getTasksWithKey:TODO AndKeyWord:_keyword];
    [self sortPeriority];
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
- (void)addTask {
    AddViewController *avc =
        [self.storyboard instantiateViewControllerWithIdentifier:@"addTask"];
    avc.delegate = self;
    [self presentViewController:avc animated:YES completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
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
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EditViewController *avc =
        [self.storyboard instantiateViewControllerWithIdentifier:@"editTask"];
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
    avc.delegate = self;

    [self.navigationController pushViewController:avc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TodoCell *cell =
        [[TodoCell alloc] initCellWithTask:(indexPath.section == 0)
                                               ? _heightArr[indexPath.row]
                                           : (indexPath.section == 1)
                                               ? _mediumArr[indexPath.row]
                                               : _lowArr[indexPath.row]
                     cellForRowAtIndexPath:indexPath
                                 tableView:tableView
                            cellIdentifier:@"todoCell"];
    return cell;
}

- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {
    _keyword = searchController.searchBar.text;
    [self getData];
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
    UIAlertAction *delete =
        [UIAlertAction actionWithTitle:@"delete"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *_Nonnull action) {
                                 [self.tasksDataSource
                                     deleteTask:(indexPath.section == 0)
                                                    ? _heightArr[indexPath.row]
                                                : (indexPath.section == 1)
                                                    ? _mediumArr[indexPath.row]
                                                    : _lowArr[indexPath.row]];
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
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
    leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *action = [UIContextualAction
        contextualActionWithStyle:UIContextualActionStyleNormal
                            title:@"InProgress"
                          handler:^(UIContextualAction *action,
                                    UIView *sourceView,
                                    void (^completionHandler)(BOOL)) {
                            Task *updatedTask = (indexPath.section == 0)
                                                    ? _heightArr[indexPath.row]
                                                : (indexPath.section == 1)
                                                    ? _mediumArr[indexPath.row]
                                                    : _lowArr[indexPath.row];
                            updatedTask.status = INPROGRESS_STATUS;
                            [_tasksDataSource editTask:updatedTask
                                             OldStatus:TODO];
                            [self refreshTable];
                            completionHandler(YES);
                          }];
    action.backgroundColor = [UIColor systemOrangeColor];
    UISwipeActionsConfiguration *configuration;

    configuration =
        [UISwipeActionsConfiguration configurationWithActions:@[ action ]];

    return configuration;
}

@end
