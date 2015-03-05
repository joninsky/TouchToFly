//
//  Tasks.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/9/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AOOs;

@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSNumber * isSES;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * objective;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) AOOs *aoo;
@property (nonatomic, retain) NSSet *references;
@property (nonatomic, retain) NSSet *tasksDescription;
@end

@interface Tasks (CoreDataGeneratedAccessors)

- (void)addReferencesObject:(NSManagedObject *)value;
- (void)removeReferencesObject:(NSManagedObject *)value;
- (void)addReferences:(NSSet *)values;
- (void)removeReferences:(NSSet *)values;

- (void)addTasksDescriptionObject:(NSManagedObject *)value;
- (void)removeTasksDescriptionObject:(NSManagedObject *)value;
- (void)addTasksDescription:(NSSet *)values;
- (void)removeTasksDescription:(NSSet *)values;

@end
