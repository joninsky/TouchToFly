//
//  SettingsAndProgressViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 3/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "SettingsAndProgressViewController.h"
#import "GlobalDecisions.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Decision.h"

@interface SettingsAndProgressViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;

@property (weak, nonatomic) IBOutlet UILabel *lblProgress;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property  NSInteger totalTasks;

@property NSInteger completedTasks;

@property (strong, nonatomic)  NSNumber *percentComplete;

@end

@implementation SettingsAndProgressViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //self.mySwitch.on = [GlobalDecisions sharedInstance].isSEL;
  
  self.mySwitch.on = [GlobalDecisions sharedInstance].isSEL;
  
  self.appDelegate = [[UIApplication sharedApplication]delegate];
  
  self.totalTasks = [self countOfAllTasks:self.appDelegate.managedObjectContext];
  
  self.completedTasks = [self finishedTasks:self.appDelegate.managedObjectContext];
  
  self.percentComplete = [[NSNumber alloc] initWithFloat:(float)self.completedTasks/self.totalTasks];
  

  
  [self.progressBar setProgress:self.percentComplete.floatValue animated:true];
  
  self.lblProgress.text = [[NSString alloc] initWithFormat:@"%.f%% Complete", 100 * self.percentComplete.floatValue ];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeClassDesignation:(id)sender {
  
  [GlobalDecisions sharedInstance].isSEL = self.mySwitch.on;
  self.totalTasks = [self countOfAllTasks:self.appDelegate.managedObjectContext];
  
  self.completedTasks = [self finishedTasks:self.appDelegate.managedObjectContext];
  
  self.percentComplete = [[NSNumber alloc] initWithFloat:(float)self.completedTasks/self.totalTasks];
  
 // NSLog(@"%@", self.percentComplete);
  
  [self.progressBar setProgress:self.percentComplete.floatValue animated:true];
  
  self.lblProgress.text = [[NSString alloc] initWithFormat:@"%.f%% Complete", 100 * self.percentComplete.floatValue ];
  
}

- (NSInteger)countOfAllTasks:(NSManagedObjectContext*)context{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
  if([GlobalDecisions sharedInstance].isSEL){
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"isSES == 0"];
    fetchRequest.predicate = thePredicate;
     return [context countForFetchRequest:fetchRequest error:nil];
  }else{
    return [self.appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:nil];
  }
}

-(NSInteger)finishedTasks:(NSManagedObjectContext*)context{
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
  if([GlobalDecisions sharedInstance].isSEL){
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"isComplete == 1 AND isSES == 0"];
    fetchRequest.predicate = thePredicate;
    return [context countForFetchRequest:fetchRequest error:nil];
  }else{
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"isComplete == 1"];
    fetchRequest.predicate = thePredicate;
    return [self.appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:nil];
  }
}


@end
