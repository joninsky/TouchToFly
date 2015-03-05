//
//  References.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/19/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tasks;

@interface References : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSNumber * isFAAReference;
@property (nonatomic, retain) NSNumber * isFavorite;
@property (nonatomic, retain) NSNumber * isVerified;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * votes;
@property (nonatomic, retain) NSString * subPhrase;
@property (nonatomic, retain) NSString * typeOfFile;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface References (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Tasks *)value;
- (void)removeTasksObject:(Tasks *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
