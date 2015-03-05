//
//  GlobalDecisions.m
//  Touch2Fly
//
//  Created by Jon Vogel on 3/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "GlobalDecisions.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Decision.h"

@interface GlobalDecisions()

@property (strong, nonatomic) Decision *theDecision;

@property (strong, nonatomic) AppDelegate *delegate;

@end




@implementation GlobalDecisions


+(GlobalDecisions *) sharedInstance{
  static dispatch_once_t onceToken;
  static GlobalDecisions *instance = nil;
  dispatch_once(&onceToken, ^{
    instance = [[GlobalDecisions alloc] init];
  });
  return instance;
}

- (id)init {
  self = [super init];
  if (self) {
    self.delegate = [[UIApplication sharedApplication]delegate];
    [self getDecisionFromCoreData];
  }
  return self;
}


-(void)getDecisionFromCoreData{
  
  
  
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Decision"];
  
  NSArray *request = [self.delegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  
  self.theDecision = request.firstObject;
  
  self.isSEL = [self.theDecision.isSEL boolValue];
}

-(void)saveCurrentStateToCoreData{
  
  NSNumber *state = [[NSNumber alloc] initWithBool:self.isSEL];
  
  self.theDecision.isSEL = state;
  
  [self.delegate.managedObjectContext save:nil];
  
  
  
}


@end
