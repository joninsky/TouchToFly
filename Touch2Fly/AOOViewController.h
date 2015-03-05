//
//  ViewController.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AOOs.h"
#import "AOOViewControllerProtocol.h"
#import "TaskViewControllerProtocol.h"



@interface AOOViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TaskViewControllerProtocol>

@property (weak, nonatomic) id<AOOViewControllerProtocol> delegate;


@end

