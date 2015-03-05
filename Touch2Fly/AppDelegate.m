//
//  AppDelegate.m
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "AppDelegate.h"
#import "AOOViewController.h"
#import "TaskViewController.h"
#import "Tasks.h"
#import "References.h"
#import "Decision.h"
#import "GlobalDecisions.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  UISplitViewController *splitView = [[UISplitViewController alloc] init];
  splitView = (UISplitViewController*)self.window.rootViewController;
  
  UITabBarController *tabBarController = splitView.viewControllers[0];
  self.detailViewNavigationController = splitView.viewControllers[1];
  
  UINavigationController *aooNavigationController = tabBarController.viewControllers[0];
  
  AOOViewController *aooViewController = aooNavigationController.viewControllers[0];
  
  TaskViewController *taskViewController = self.detailViewNavigationController.viewControllers[0];
  
  aooViewController.delegate = taskViewController;
  taskViewController.delegate = aooViewController;
  
  [self seedReferences];
  // Override point for customization after application launch.
  return YES;
}



-(void)seedReferences{
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"References"];
  NSInteger numberOFResults = [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
  
  if (numberOFResults == 0 ){
    
    Decision *referenceDecision = [NSEntityDescription  insertNewObjectForEntityForName:@"Decision" inManagedObjectContext:self.managedObjectContext];
    referenceDecision.isSEL = [[NSNumber alloc] initWithInt:1];
    
    NSURL *seedURL = [[NSBundle mainBundle] URLForResource:@"Seed" withExtension:@"json"];
    
    NSData *dataFromSeed = [[NSData alloc] initWithContentsOfURL:seedURL];
    
    NSError *jsonError;
    
    NSDictionary *dictionaryOfTasks = [NSJSONSerialization JSONObjectWithData:dataFromSeed options:0 error:&jsonError];
    
    if (dictionaryOfTasks) {
      
      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
      
      NSArray *theTasks = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
      
      //NSLog(@"%lu", (unsigned long)theTasks.count );
      
      for (Tasks *t in theTasks){
        NSLog(@"%@", t.phrase);
          NSArray *arrayOfReferences = dictionaryOfTasks[t.phrase];
        NSLog(@"%lu", (unsigned long)arrayOfReferences.count);
        NSMutableSet *setOfReferences = [[NSMutableSet alloc] init];
       // NSLog(@"%@", t.phrase);
        for (NSDictionary *r in arrayOfReferences){
          References *reference = [NSEntityDescription  insertNewObjectForEntityForName:@"References" inManagedObjectContext:self.managedObjectContext];
          reference.dateAdded = [[NSDate alloc] init];
          reference.isFAAReference = r[@"isFAA"];
          reference.isFavorite = r[@"isFavorite"];
          reference.isVerified = r[@"isVerified"];
          reference.phrase = r[@"phrase"];
          reference.url = r[@"url"];
          reference.votes = r[@"votes"];
          reference.subPhrase = r[@"subPhrase"];
          reference.typeOfFile = r[@"typeOfFile"];
          [setOfReferences addObject:reference];
        }
        t.references = setOfReferences;
      }
      
      [self.managedObjectContext save:nil];
    }
  }
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [[GlobalDecisions sharedInstance] saveCurrentStateToCoreData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Me.Touch2Fly" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Touch2Fly" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PPLData.sqlite"];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:storeURL.path] == false){
    NSURL *defaultURL = [[NSBundle mainBundle] URLForResource:@"PPLData" withExtension:@"sqlite"];
    if (defaultURL) {
      [fileManager copyItemAtURL:defaultURL toURL:storeURL error:nil];
    }
  }
  
  
  NSDictionary *coordinatorOptions = @{
                                       NSMigratePersistentStoresAutomaticallyOption : @YES,
                                       NSInferMappingModelAutomaticallyOption: @YES
                                       };
  
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:coordinatorOptions error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
