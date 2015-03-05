//
//  TaskDetailViewController.h
//  Touch2Fly
//
//  Created by Jon Vogel on 2/8/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import <QuickLook/QuickLook.h>

@interface TaskDetailViewController : UIViewController <QLPreviewControllerDataSource, QLPreviewControllerDelegate>
@property (strong, nonatomic) Tasks *theTask;
@end
