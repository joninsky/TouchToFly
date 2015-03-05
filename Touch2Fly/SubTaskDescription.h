//
//  SubTaskDescription.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/9/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubTaskDescription : NSManagedObject

@property (nonatomic, retain) NSNumber * isClutter;
@property (nonatomic, retain) NSString * phrase;
@property (nonatomic, retain) NSManagedObject *taskdescription;

@end
