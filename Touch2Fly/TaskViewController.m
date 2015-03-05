//
//  TaskViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "TaskViewController.h"
#import "AOOs.h"
#import "Tasks.h"
#import "TaskCellController.h"
#import "TaskDetailViewController.h"
#import "GlobalDecisions.h"
#import "SettingsAndProgressViewController.h"


@interface TaskViewController ()



@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//Properties that will get set when the delegate passAOO funciton get called
@property (strong,nonatomic) AOOs *theAOO;
@property (strong, nonatomic) NSArray *arrayOfTasks;

//Outlet for the bar button item that displays notes
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNote;


@end

@implementation TaskViewController


//MARK: App Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
  //Set the tableview datasource and delegates
  self.myTableView.dataSource = self;
  self.myTableView.delegate = self;
  //Set up the table view Cells
  UINib *taskCell = [UINib nibWithNibName:@"TaskCellController" bundle:[NSBundle mainBundle]];
  [self.myTableView registerNib:taskCell forCellReuseIdentifier:@"taskCell"];
  self.myTableView.estimatedRowHeight = 57;
  self.myTableView.rowHeight = UITableViewAutomaticDimension;
  //Set the title
  self.navigationItem.title = @"Please Select an Area of Operation";
  //Set the note button state
  self.btnNote.enabled = false;

}

-(void)viewWillAppear:(BOOL)animated{
  
  
  
  [super viewWillAppear:animated];
  [self.theAOO.managedObjectContext save:nil];
  [self.delegate communicate];
  [self passAOO:self.theAOO];
  [self.myTableView reloadData];
}

//MARK: Protocol method
-(void)passAOO:(AOOs*)theAoo{
  //Set the property that belongs to this class to the AOO that is getting passed to us fromt he mastr view controller
  self.theAOO = theAoo;
  
  //Check the global variable to see if the user has selected SES or SEL
  if ([GlobalDecisions sharedInstance].isSEL){
    //If the user only wants SEL tasks we need a predicate to filter the tasks based on the isSES property
    NSPredicate *predicateForSEL = [NSPredicate predicateWithFormat:@"isSES == 0"];
    //No need to fetch, we can get all the tasks from the property that represents them in theAOO that was given to us.
    self.arrayOfTasks = [theAoo.tasks allObjects];
    //Set the arrayOfTasks to the filtered array of tasks.
    self.arrayOfTasks = [self.arrayOfTasks filteredArrayUsingPredicate:predicateForSEL];
    //However, we have to sort them, here we create the sort descriptor and put it inot an array
    NSSortDescriptor *theSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"phrase" ascending:true selector:@selector(localizedStandardCompare:)];
    NSArray *arrayOfDescriptors = [NSArray arrayWithObjects:theSortDescriptor, nil];
    //We basically relaod the array of tasks with the sort descriptior
    self.arrayOfTasks = [self.arrayOfTasks sortedArrayUsingDescriptors:arrayOfDescriptors];
  }else{
    //No need to fetch, we can get all the tasks from the property that represents them in theAOO that was given to us.
    self.arrayOfTasks = [theAoo.tasks allObjects];
    //However, we have to sort them, here we create the sort descriptor and put it inot an array
    NSSortDescriptor *theSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"phrase" ascending:true selector:@selector(localizedStandardCompare:)];
    NSArray *arrayOfDescriptors = [NSArray arrayWithObjects:theSortDescriptor, nil];
    //We basically relaod the array of tasks with the sort descriptior
    self.arrayOfTasks = [self.arrayOfTasks sortedArrayUsingDescriptors:arrayOfDescriptors];
  }
  
  //Now do a little configurating, set the title of the page and chack to see if this AOO has a note
  self.navigationItem.title = theAoo.phrase;
  if (![self.theAOO.note isEqualToString:@""]){
    self.btnNote.enabled = true;
  }else{
    self.btnNote.enabled = false;
  }
  //Finally reload the data in the table view.
  [self.myTableView reloadData];
  [self.navigationController popToRootViewControllerAnimated:true];
}



//MARK: TableView datasource methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (self.arrayOfTasks.count != 0){
    return self.arrayOfTasks.count;
  }else{
    return 1;
  }
  
  
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  TaskCellController *Cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
  if (self.arrayOfTasks.count != 0){
    Tasks *theTask = self.arrayOfTasks[indexPath.row];
   // NSLog(@"%@", theTask.isComplete);
    Cell.lblTaskDescription.text = theTask.phrase;
    if ([theTask.isComplete boolValue] == [[[NSNumber alloc]initWithBool:YES] boolValue]){
      Cell.backgroundColor = [[UIColor alloc] initWithRed:211/255.f green:245/255.f blue:221/255.f alpha:1.0];     }else{
      Cell.backgroundColor = [UIColor whiteColor];
    }
  }else{
    Cell.lblTaskDescription.text = @" ";
  }
  return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self performSegueWithIdentifier:@"showDetailView" sender:self];
}


//MARK: NoteButton Action
- (IBAction)noteButtonPressed:(id)sender {
  //Create an alert view that will contain the Note from the AOO
  UIAlertController *noteAlert =[UIAlertController alertControllerWithTitle:@"Note!" message:self.theAOO.note preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Thanks" style:UIAlertActionStyleDefault handler:nil];
  [noteAlert addAction:okAction];
  [self presentViewController:noteAlert animated:true completion:nil];
  
}


//MARK: Perfor Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if ([segue.identifier  isEqual: @"showDetailView"]){
    TaskDetailViewController *DVC = segue.destinationViewController;
    NSIndexPath *thePath = [self.myTableView indexPathForSelectedRow];
    DVC.theTask = self.arrayOfTasks[thePath.row];
  }
}




@end
