//
//  MoreStuffTableViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 3/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "MoreStuffTableViewController.h"
#import "SettingsAndProgressViewController.h"
#import "AppDelegate.h"

@interface MoreStuffTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) AppDelegate *delegate;

@property (strong, nonatomic) SettingsAndProgressViewController *NVC;
@end

@implementation MoreStuffTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.delegate = [[UIApplication sharedApplication]delegate];

 self.NVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsandProgress"];
  
  [self.delegate.detailViewNavigationController pushViewController:self.NVC animated:true];
  
  [self.NVC.navigationItem setHidesBackButton:true];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  if (![self.delegate.detailViewNavigationController.topViewController isKindOfClass:[SettingsAndProgressViewController class]]){
    [self.delegate.detailViewNavigationController pushViewController:self.NVC animated:true];
    
  }
  
  [self.navigationController.tabBarItem setImage:[[UIImage imageNamed:@"FlightBag.jpeg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
  
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  if (indexPath.row == 0){
    self.NVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsandProgress"];
    
      if (![self.delegate.detailViewNavigationController.topViewController isKindOfClass:[SettingsAndProgressViewController class]]){
        [self.delegate.detailViewNavigationController popToRootViewControllerAnimated:false];
        [self.delegate.detailViewNavigationController pushViewController:self.NVC animated:true];

          }

      }
  
}


@end
