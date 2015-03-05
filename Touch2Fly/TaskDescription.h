//
//  TaskDescription.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/9/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubTaskDescription, Tasks;

@interface TaskDescription : NSManagedObject

@property (nonatomic, retain) NSNumber * isClutter;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSSet *subTaskDescription;
@property (nonatomic, retain) Tasks *tasks;
@end

@interface TaskDescription (CoreDataGeneratedAccessors)

- (void)addSubTaskDescriptionObject:(SubTaskDescription *)value;
- (void)removeSubTaskDescriptionObject:(SubTaskDescription *)value;
- (void)addSubTaskDescription:(NSSet *)values;
- (void)removeSubTaskDescription:(NSSet *)values;

@end
