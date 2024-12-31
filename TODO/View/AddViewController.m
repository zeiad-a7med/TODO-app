//
//  AddViewController.m
//  TODO
//
//  Created by Zeiad on 30/12/2024.
//

#import "AddViewController.h"
#import "../Models/Task.h"
#import "../constants/Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface AddViewController ()
@property(strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailsTextField;
@property (weak, nonatomic) IBOutlet UILabel *documentTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateField;
@property NSURL * selectedDocument;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedDocument = [NSURL new];
    [self initSegmentController];
    _tasksDataSource = [TasksDataSource new];
}
- (IBAction)pickFile:(id)sender {
    
    NSArray *documentTypes = @[(__bridge NSString *)kUTTypePlainText, (__bridge NSString *)kUTTypeText, (__bridge NSString *)kUTTypePDF]; // Specify types of files you want to support
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
    
    
    documentPicker.delegate = self;
    
    [self presentViewController:documentPicker animated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    _selectedDocument = urls.firstObject;
    _documentTitle.text = _selectedDocument.lastPathComponent;
//    [self displayFileAtURL:_selectedDocument];
}
- (void)displayFileAtURL:(NSURL *)fileURL {
    // Read the file content
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
        return;
    }
    
    // Create a UITextView to display the file content
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.text = fileContent;
    [self.view addSubview:textView];
}
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    NSLog(@"Document picker was cancelled.");
}
- (void)initSegmentController {

    NSArray *items = @[ @"Low", @"Medium",@"Height" ];
    _segment = [[UISegmentedControl alloc] initWithItems:items];
    _segment.frame = CGRectMake(150, 390, 220, 40);
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self
                  action:@selector(segmentValueChanged:)
        forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:_segment];
    
    _detailsTextField.borderStyle = UITextBorderStyleRoundedRect;
    _detailsTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [_detailsTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:15],
        [_detailsTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-15],
        [_detailsTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:257],
        [_detailsTextField.heightAnchor constraintEqualToConstant:100]
    ]];
}
- (void)segmentValueChanged:(UISegmentedControl *)sender {
}
- (IBAction)save:(id)sender {
    Task * task = [Task new];
    task.title = _titleTextField.text;
    task.details = _detailsTextField.text;
    task.status = TODO_STATUS;
    task.periority = _segment.selectedSegmentIndex+1;
    task.endDate = _dateField.date;
    task.document = _selectedDocument;
    if([task validFields]){
        [_tasksDataSource addTask:task];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"missing field" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_delegate refreshTable];
}



@end
