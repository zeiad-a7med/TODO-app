//
//  EditViewController.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "EditViewController.h"
#import "../constants/Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DocumentViewController.h"
@interface EditViewController ()
@property(strong, nonatomic) IBOutlet UISegmentedControl *perioritySegment;
@property(strong, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (strong, nonatomic) NSSet *disabledSegments;
@property(weak, nonatomic) IBOutlet UITextField *titleTextField;
@property(weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property(weak, nonatomic) IBOutlet UIDatePicker *dateField;
@property Task *updatedTask;
@property (weak, nonatomic) IBOutlet UILabel *documentLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewDocumentBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadDocumentBtn;
@property (weak, nonatomic) IBOutlet UILabel *documentName;
@property NSURL * selectedDocument;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(allowEdit)];
    [self initSegmentController];
    _tasksDataSource = [TasksDataSource new];
    _titleTextField.text = _task.title;
    _detailsTextField.text = _task.details;
    _dateField.date = _task.endDate;
    if (_task.document.path != nil) {
        _documentName.text = _task.document.lastPathComponent;
        _documentLabel.text = @"Document";
        _viewDocumentBtn.hidden = NO;
        _selectedDocument = _task.document;
    }
    
    
    _titleTextField.enabled = NO;
    _detailsTextField.enabled = NO;
    _dateField.enabled = NO;
    _statusSegment.enabled = NO;
    _perioritySegment.enabled = NO;
    
    
    _detailsTextField.borderStyle = UITextBorderStyleRoundedRect;
    _detailsTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [_detailsTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
        [_detailsTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
        [_detailsTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:257],
        [_detailsTextField.heightAnchor constraintEqualToConstant:100]
    ]];
}
- (IBAction)viewDocument:(id)sender {
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfURL:_selectedDocument encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return;
    }
    DocumentViewController *dvc =
        [self.storyboard instantiateViewControllerWithIdentifier:@"documentViewer"];
    dvc.content = fileContent;
    [self presentViewController:dvc animated:YES completion:nil];
}
- (IBAction)uploadDocument:(id)sender {
    
    NSArray *documentTypes = @[(__bridge NSString *)kUTTypePlainText, (__bridge NSString *)kUTTypeText, (__bridge NSString *)kUTTypePDF]; // Specify types of files you want to support
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
    
    
    documentPicker.delegate = self;
    
    [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    _selectedDocument = urls.firstObject;
    _documentName.text = _selectedDocument.lastPathComponent;
    _documentLabel.text = @"Document";
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Document picker was cancelled.");
}
- (void)initSegmentController {
    NSArray *items = @[ @"Low", @"Medium", @"Height" ];
    _perioritySegment = [[UISegmentedControl alloc] initWithItems:items];
    _perioritySegment.frame = CGRectMake(150, 390, 220, 40);
    _perioritySegment.selectedSegmentIndex = _task.periority - 1;
    [_perioritySegment addTarget:self
                          action:@selector(segmentValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_perioritySegment];
    NSArray *statusItems = @[ @"TODO", @"In Progress", @"Done" ];
    _statusSegment = [[UISegmentedControl alloc] initWithItems:statusItems];
    _statusSegment.frame = CGRectMake(100, 445, 280, 40);
    _statusSegment.selectedSegmentIndex = _task.status - 1;

    [_statusSegment addTarget:self
                       action:@selector(segmentValueChanged:)
             forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_statusSegment];
}
- (void)segmentValueChanged:(UISegmentedControl *)sender {
}
- (void)allowEdit {
    _titleTextField.enabled = YES;
    _detailsTextField.enabled = YES;
    _dateField.enabled = YES;
    _statusSegment.enabled = YES;
    _perioritySegment.enabled = YES;
    _uploadDocumentBtn.hidden = NO;
    _viewDocumentBtn.hidden = YES;
    if(_task.status != TODO_STATUS){
        self.disabledSegments = [NSSet new];
        for (int i = _task.status-2; i>=0; i--) {
            NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
            [self.statusSegment setEnabled:NO forSegmentAtIndex:i];
        }
    }
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(save)];
}
- (void)save {
    _updatedTask = [Task new];
    _updatedTask.tid = _task.tid;
    _updatedTask.title = _titleTextField.text;
    _updatedTask.details = _detailsTextField.text;
    _updatedTask.status = _statusSegment.selectedSegmentIndex + 1;
    _updatedTask.periority = _perioritySegment.selectedSegmentIndex + 1;
    _updatedTask.status = _statusSegment.selectedSegmentIndex + 1;
    _updatedTask.endDate = _dateField.date;
    _updatedTask.document = _selectedDocument;
    if ([_task validFields]) {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Are you sure you want to Edit this Task"
                             message:@""
                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction
            actionWithTitle:@"ok"
                      style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction *_Nonnull action) {
            [self.tasksDataSource editTask:self.updatedTask OldStatus:[self.task getStatusKey]];
                      [self.navigationController popViewControllerAnimated:YES];
                    }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"missing field"
                             message:@""
                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =
            [UIAlertAction actionWithTitle:@"ok"
                                     style:UIAlertActionStyleDefault
                                   handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [_delegate refreshTable];
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
