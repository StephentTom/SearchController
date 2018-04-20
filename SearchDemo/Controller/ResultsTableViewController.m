//
//  ResultsTableViewController.m
//  NewSearchDemo
//
//  Created by Macmini on 2018/4/18.
//  Copyright © 2018年 Macmini. All rights reserved.
//

#import "ResultsTableViewController.h"
#import "Product.h"

@interface ResultsTableViewController ()

@end

@implementation ResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifire];
    
    Product *product = self.filteredArray[indexPath.row];
    [self configureCell:cell forProduct:product];
    
    return cell;
}


@end
