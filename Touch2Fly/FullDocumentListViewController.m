//
//  FullDocumentListViewController.m
//  Touch2Fly
//
//  Created by Jon Vogel on 3/2/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "FullDocumentListViewController.h"
#import <QuickLook/QuickLook.h>

@interface FullDocumentListViewController () <UITableViewDataSource, UITableViewDelegate,QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSArray *arrayOfDocuments;

@property (strong, nonatomic) QLPreviewController *previewController;

@end

@implementation FullDocumentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.myTableView.dataSource = self;
  self.myTableView.delegate = self;
  
  self.arrayOfDocuments = [NSArray arrayWithObjects: @"AC 150-5340-18F Standards for Airport Signs", @"AC 00-6A Aviation Weather", @"AC 61-67C  Stall and Spin Training", @"AC 91-73B Taxi Operations", @"AC-00-45G Aviation Weather Services", @"AC 61-84B Role of Preflight Preparation", @"AC 90-66A Standard Traffic Patterns at Uncontrolled Airports", @"AC 91-13C Cold Weather Operations", @"AC 91-55 Reduction of Electrical Failures", @"Coast Guard Navigation Rules and Regulations Handbook", @"errata_sheet_150_5340_18f",  @"Aircraft Weight and Balance Handbook", @"Airplane Flying Handbook", @"Advanced Avionics Handbook", nil];
  
  self.previewController = [[QLPreviewController alloc]init];
  self.previewController.dataSource = self;
  self.previewController.delegate  = self;
  [self.previewController reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Table view data source methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.arrayOfDocuments.count;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"listAllCell" forIndexPath:indexPath];
  
  
  Cell.textLabel.text = self.arrayOfDocuments[indexPath.row];
  
  
  return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [self.previewController refreshCurrentPreviewItem];
  [self presentViewController:self.previewController animated:true completion:^{
    
    
    
  }];
  


}

//MARK: Delegate methods for the QLPreviewController
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
  //NSLog(@"%lu", (unsigned long)[self.arrayOfReferences count]);
  
  return 1;
}

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
  
  
  
  NSString *urlForPDF = self.arrayOfDocuments[[self.myTableView indexPathForSelectedRow].row ];
  NSString *File = [[NSBundle mainBundle] pathForResource:urlForPDF ofType:@"pdf"];
  
  NSLog([QLPreviewController canPreviewItem:[NSURL fileURLWithPath:File]] ? @"Yes" : @"NO");

  
  return [NSURL fileURLWithPath:File];
  
}


@end
