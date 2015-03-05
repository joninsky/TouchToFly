//
//  TaskViewController.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOOViewControllerProtocol.h"
#import "TaskViewControllerProtocol.h"

@interface TaskViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AOOViewControllerProtocol>

@property (strong, nonatomic) id<TaskViewControllerProtocol> delegate;

@end
