//
//  TaskDetailViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "TaskDetailViewController.h"
#import <QuickLook/QuickLook.h>
#import "TaskDescription.h"
#import "SubTaskDescription.h"
#import "References.h"

@interface TaskDetailViewController () <UITableViewDataSource, UITableViewDelegate>
//Outlet for Note Button so I can set the state
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNote;
//Property of type QLPreviewController
@property (strong, nonatomic) QLPreviewController *previewController;
//Create outlet for the Switch
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
//Outled for text field that contains objective
@property (weak, nonatomic) IBOutlet UITextView *txtObjective;
//Outlet for text field that contains the description
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
//Array that will hold all the PDF we are going to load into the Preview Controller
@property (strong, nonatomic) NSArray *arrayOfReferences;
//TableView outlet for references table view
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation TaskDetailViewController


//MARK: App Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
  
  //Set the title of the page to the current task
  self.navigationItem.title = self.theTask.phrase;
  self.automaticallyAdjustsScrollViewInsets = false;
  
  //Enable the buton if a note is available for the task
  if (![self.theTask.note isEqualToString:@""]){
    self.btnNote.enabled = true;
  }else{
    self.btnNote.enabled = false;
  }
  
  //Set the switch state according to the state of isCOmplete for the task
  if ([self.theTask.isComplete boolValue] == [[[NSNumber alloc] initWithInt:1] boolValue]){
    self.mySwitch.on = true;
  }else{
    self.mySwitch.on = false;
  }
  
  //Set the table view delegate and datasource
  self.myTableView.dataSource = self;
  self.myTableView.delegate = self;
  
  //Instantiate the Preview Controller
  self.previewController = [[QLPreviewController alloc]init];
  self.previewController.dataSource = self;
  self.previewController.delegate  = self;
//  [self addChildViewController:self.previewController];
//  CGFloat w = self.view.frame.size.width;
//  CGFloat h = self.view.frame.size.height;
//  self.previewController.view.frame = CGRectMake(0, h/2, w, h);
//  [self.view addSubview:self.previewController.view];
//  [self.previewController didMoveToParentViewController:self];
  
  self.txtObjective.text = self.theTask.objective;
  [self populateDescripiton:self.theTask];
  
  
  self.arrayOfReferences = [[NSArray alloc] initWithArray:[self.theTask.references allObjects]];
  
  [self.previewController reloadData];
}

-(void)populateDescripiton:(Tasks*)theTask{
  NSSortDescriptor *theSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"phrase" ascending:true selector:@selector(localizedStandardCompare:)];
  NSArray *arrayOfDescriptors = [NSArray arrayWithObjects:theSortDescriptor, nil];

  NSArray *arrayOfDescriptions = [[NSArray alloc] initWithArray:[theTask.tasksDescription allObjects]];
  arrayOfDescriptions = [arrayOfDescriptions sortedArrayUsingDescriptors:arrayOfDescriptors];
  for (TaskDescription *d in arrayOfDescriptions){
    
    self.txtDescription.text =  [[NSString alloc] initWithFormat:@"%@ \n %@ \n", self.txtDescription.text, d.phrase ];
    
    if (d.subTaskDescription){
      NSArray *arrayOfSubTaskDescriptions = [[NSArray alloc]initWithArray:[d.subTaskDescription allObjects]];
      arrayOfSubTaskDescriptions = [arrayOfSubTaskDescriptions sortedArrayUsingDescriptors:arrayOfDescriptors];
      for (SubTaskDescription *ST in arrayOfSubTaskDescriptions){
        self.txtDescription.text = [[NSString alloc]initWithFormat:@"%@ \n \t %@ \n", self.txtDescription.text, ST.phrase];
      }
    }
  }
}

//MARK: Delegate and datasource methods for Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [self.arrayOfReferences count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"referenceCell" forIndexPath:indexPath];
  References *theReference = self.arrayOfReferences[indexPath.row];
  
  Cell.textLabel.text = theReference.phrase;
  Cell.detailTextLabel.text = theReference.subPhrase;
  
  return Cell;
  
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  [self.previewController refreshCurrentPreviewItem];
  [self presentViewController:self.previewController animated:true completion:^{
    
    
    
  }];
}


//MARK: Delegate methods for the QLPreviewController
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
  //NSLog(@"%lu", (unsigned long)[self.arrayOfReferences count]);
  
  return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
  
  References *theReference = self.arrayOfReferences[[self.myTableView indexPathForSelectedRow].row];
  
  NSString *urlForPDF = theReference.url;
  
  NSString *File = [[NSBundle mainBundle] pathForResource:urlForPDF ofType:@"pdf"];
  
  return [[NSURL alloc] initFileURLWithPath:File];
  
}




//MARK: Action For note button
- (IBAction)noteButtonPressed:(id)sender {
  
  UIAlertController *noteAlert = [UIAlertController alertControllerWithTitle:@"Note!" message:self.theTask.note preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Thanks" style:UIAlertActionStyleDefault handler:nil];
  [noteAlert addAction:dismissAction];
  
  [self presentViewController:noteAlert animated:true completion:nil];
}



- (IBAction)mastered:(id)sender {
  if (self.mySwitch.on){
    self.theTask.isComplete = [[NSNumber alloc]initWithInt:1];
    //NSLog(@"%@", self.theTask.isComplete);
  }else{
    self.theTask.isComplete = [[NSNumber alloc]initWithInt:0];
    //NSLog(@"%@", self.theTask.isComplete);
  }
}



@end
