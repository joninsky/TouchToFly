//
//  GlobalDecisions.h
//  Touch2Fly
//
//  Created by Jon Vogel on 3/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalDecisions : NSObject

@property BOOL isSEL;

+(GlobalDecisions *) sharedInstance;

-(void)saveCurrentStateToCoreData;

@end
