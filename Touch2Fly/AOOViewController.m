//
//  ViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "AOOViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AOOCellController.h"
#import "AOOs.h"
#import "Tasks.h"
#import "GlobalDecisions.h"
#import "SettingsAndProgressViewController.h"

@interface AOOViewController ()

//Properties that will be used to get the managed object context
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *myManagedObjectContext;

//Property/Outlet for the tableview
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//Array that will contain all the AOO's
@property (strong, nonatomic) NSArray *arrayOfAOOs;

@property (strong, nonatomic) UIImage *redX;


@end

@implementation AOOViewController

//MARK: App Life Cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  //Set the navigation bar title
  self.navigationItem.title = @"Areas Of Operation";
  //Set up the app delegate and managed object context
  self.appDelegate = [[UIApplication sharedApplication] delegate];
  self.myManagedObjectContext = self.appDelegate.managedObjectContext;
  //Set the tableView datasource and delegate
  self.myTableView.dataSource = self;
  self.myTableView.delegate = self;
  //Register the XIB for so we hav a Cell to display.
  UINib *AOOXib = [UINib nibWithNibName:@"AOOCellController" bundle:[NSBundle mainBundle]];
  [self.myTableView registerNib:AOOXib forCellReuseIdentifier:@"AOOCell"];
  //Configure the table view to automatically resize the Cells based on content of the Lable.
  self.myTableView.estimatedRowHeight = 77;
  self.myTableView.rowHeight = UITableViewAutomaticDimension;
  //Set the array of AOOS tot eh returned results from the fetch rquest
  self.arrayOfAOOs = [self fetchAOOs:self.myManagedObjectContext];
  NSString *redXFilePath = [[NSBundle mainBundle] pathForResource:@"redx" ofType:@"png"];
  self.redX = [UIImage imageWithContentsOfFile: redXFilePath ];
  for (AOOs *a in self.arrayOfAOOs){
    [self checkAOOisComplete:a];
  }
  [self.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"FlightBag.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
  
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  if ([self.appDelegate.detailViewNavigationController.topViewController isKindOfClass:[SettingsAndProgressViewController class]]){
    [self.appDelegate.detailViewNavigationController popViewControllerAnimated:true];
  }
  
  
}

-(void)communicate{
  for (AOOs *a in self.arrayOfAOOs){
    [self checkAOOisComplete:a];
  }
  
  [self.myTableView reloadData];
}




//MARK: CoreData Functions.
-(NSArray *)fetchAOOs: (NSManagedObjectContext*)context{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"AOOs"];
  NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
  if (results){
    return results;
  }else{
    return nil;
  }
}



//MARK: TableView Datasource adn Delegate funcitons
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.arrayOfAOOs.count != 0){
    return self.arrayOfAOOs.count;
  }else{
    return 1;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  AOOCellController *Cell = [tableView dequeueReusableCellWithIdentifier:@"AOOCell" forIndexPath:indexPath];
  if (self.arrayOfAOOs.count != 0) {
    AOOs *theAOO = self.arrayOfAOOs[indexPath.row];
    Cell.lblText.text = theAOO.phrase;
    NSNumber *theInt = [[NSNumber alloc]initWithBool:NO];
    if ([theAOO.isComplete boolValue] == [theInt boolValue]) {
      Cell.completeImage.image = [UIImage imageNamed:@"redx.png"];
    }else{
      Cell.completeImage.image = [UIImage imageNamed:@"greenCheck.png"];
    }
  }else{
    Cell.lblText.text = @"No Areas of Operation";
  }
  
  return Cell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  NSIndexPath *thePath = [self.myTableView indexPathForSelectedRow];
  AOOs *theAOO = [self.arrayOfAOOs objectAtIndex:thePath.row];
  [self.delegate passAOO:theAOO];
  
}


-(void)checkAOOisComplete:(AOOs*)theAOO{
  
  NSArray *arrayOfTasks;
  
  if ([GlobalDecisions sharedInstance].isSEL){
    //If the user only wants SEL tasks we need a predicate to filter the tasks based on the isSES property
    NSPredicate *predicateForSEL = [NSPredicate predicateWithFormat:@"isSES == 0"];
    //No need to fetch, we can get all the tasks from the property that represents them in theAOO that was given to us.
    arrayOfTasks = [theAOO.tasks allObjects];
    //Set the arrayOfTasks to the filtered array of tasks.
    arrayOfTasks = [arrayOfTasks filteredArrayUsingPredicate:predicateForSEL];
  }else{
    //No need to fetch, we can get all the tasks from the property that represents them in theAOO that was given to us.
    arrayOfTasks = [theAOO.tasks allObjects];
  }
  
  
  
  NSInteger numberOfTasks = arrayOfTasks.count;
  NSInteger numberOfCompletedTasks = 0;
  for (Tasks *t in arrayOfTasks){
    if ([t.isComplete boolValue] == [[[NSNumber alloc]initWithInt:1] boolValue]){
      numberOfCompletedTasks++;
    }
  }
  
  if (numberOfCompletedTasks == numberOfTasks){
    theAOO.isComplete = [[NSNumber alloc]initWithInt:1];
  }else{
    theAOO.isComplete = [[NSNumber alloc]initWithInt:0];
  }
  
}






@end
