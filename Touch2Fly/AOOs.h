//
//  AOOs.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/9/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AOOs : NSManagedObject

@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface AOOs (CoreDataGeneratedAccessors)

- (void)addTasksObject:(NSManagedObject *)value;
- (void)removeTasksObject:(NSManagedObject *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
